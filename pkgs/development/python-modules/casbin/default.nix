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
  version = "1.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "1majsbpldsch3wgg7pdm87vk9dhqll9nk2pjjvqp8rvg93x2kkww";
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
