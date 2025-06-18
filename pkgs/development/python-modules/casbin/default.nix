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
  pname = "casbin";
  version = "1.43.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "casbin";
    repo = "pycasbin";
    tag = "v${version}";
    hash = "sha256-vRT8Z0XHDPOnAxy67j88vBX6W20mRWY7O/IrGLM/vuQ=";
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
