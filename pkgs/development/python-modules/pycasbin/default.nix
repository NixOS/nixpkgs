{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  simpleeval,
  wcmatch,
}:

buildPythonPackage rec {
  pname = "pycasbin";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "casbin";
    repo = "pycasbin";
    tag = "v${version}";
    hash = "sha256-JSaQq5BX+aXJ2iaCudzbCcMwNnf4INS/iWfMOua6fjw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    simpleeval
    wcmatch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "casbin" ];

  meta = with lib; {
    description = "Authorization library that supports access control models like ACL, RBAC and ABAC";
    homepage = "https://github.com/casbin/pycasbin";
    changelog = "https://github.com/casbin/pycasbin/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
