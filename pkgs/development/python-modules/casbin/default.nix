{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, isPy27
, coveralls
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "0.8.4";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "0g8q3i5w5pkfazgdpx9q93df6a3v792md1csqhnl97bprp8minfa";
  };

  propagatedBuildInputs = [
    simpleeval
  ];

  checkInputs = [
    coveralls
  ];

  checkPhase = ''
    coverage run -m unittest discover -s tests -t tests
  '';

  meta = with lib; {
    description = "An authorization library that supports access control models like ACL, RBAC, ABAC in Python";
    homepage = "https://github.com/casbin/pycasbin";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
