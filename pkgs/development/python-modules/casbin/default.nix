{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, isPy27
, coveralls
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "0.19.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "0fkkz5k3h4pkxacrbacamnh4yfghxgajdzzmdlck7i4v5x06vz8f";
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
