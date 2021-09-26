{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, isPy27
, coveralls
, wcmatch
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "1.9.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "01prcwkmh3a4ggzjiaai489rrpmgwvqpjcavwjxw60mspyhsbv86";
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
