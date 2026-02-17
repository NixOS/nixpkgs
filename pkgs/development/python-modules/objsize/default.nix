{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "objsize";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "objsize";
    tag = version;
    hash = "sha256-u4PTUk3K3ZCNZ87xM+PoCabsw+EjOoDgNySDWWB7yho=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "objsize" ];

  enabledTestPaths = [ "test_objsize.py" ];

  meta = {
    description = "Traversal over objects subtree and calculate the total size";
    homepage = "https://github.com/liran-funaro/objsize";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ocfox ];
  };
}
