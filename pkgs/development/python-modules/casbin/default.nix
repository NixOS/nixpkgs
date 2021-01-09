{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, isPy27
, coveralls
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "0.15.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "0w34xs9qpf1x4rq2ri4fhx3yi8h4inzavv9hjsx8mlkzid7gdx1b";
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
