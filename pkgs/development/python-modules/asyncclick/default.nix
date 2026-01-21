{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "asyncclick";
  version = "8.3.0.5+async";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "asyncclick";
    tag = version;
    hash = "sha256-gKtxwI/vDB2pDrhiA+e1TClwW5nXvBRCMF3oCNoLaDo=";
  };

  build-system = [ flit-core ];

  dependencies = [ anyio ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
  ];

  pytestFlags = [
    "-Wignore::trio.TrioDeprecationWarning"
  ];

  disabledTests = [
    # AttributeError: 'Context' object has no attribute '_ctx_mgr'
    "test_context_pushing"
  ];

  pythonImportsCheck = [ "asyncclick" ];

  meta = {
    description = "Python composable command line utility";
    homepage = "https://github.com/python-trio/asyncclick";
    changelog = "https://github.com/python-trio/asyncclick/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
