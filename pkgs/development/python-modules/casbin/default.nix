{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, isPy27
, coveralls
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "0.16.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "1bjrg0ig40rjk5x65x7ac9xsl332r0ypqgrqjdivb5dvplifnw36";
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
