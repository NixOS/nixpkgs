{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, simpleeval
, wcmatch
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "1.35.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "casbin";
    repo = "pycasbin";
    rev = "refs/tags/v${version}";
    hash = "sha256-XVFuRmeQwm+3kyO71F8nxB+VdaPS+5oTAk5XqcjvkCM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    simpleeval
    wcmatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "casbin"
  ];

  meta = with lib; {
    description = "Authorization library that supports access control models like ACL, RBAC and ABAC";
    homepage = "https://github.com/casbin/pycasbin";
    changelog = "https://github.com/casbin/pycasbin/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
