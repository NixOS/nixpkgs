{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, pythonOlder
, coveralls
, wcmatch
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "1.16.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-l98QfrRg7ghZ+jT9J2BNILUcinOKwhpnIMS+W8NQFr4=";
  };

  propagatedBuildInputs = [
    simpleeval
    wcmatch
  ];

  checkInputs = [
    coveralls
  ];

  checkPhase = ''
    coverage run -m unittest discover -s tests -t tests
  '';

  pythonImportsCheck = [
    "casbin"
  ];

  meta = with lib; {
    description = "An authorization library that supports access control models like ACL, RBAC, ABAC in Python";
    homepage = "https://github.com/casbin/pycasbin";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
