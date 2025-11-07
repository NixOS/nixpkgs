{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
  trio,
}:

buildPythonPackage rec {
  pname = "asyncclick";
  version = "8.1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "asyncclick";
    tag = "${version}+async";
    hash = "sha256-J294pYuNOSm7v2BbwDpzn3uelAnZ3ip2U1gWuchhOtA=";
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

  meta = with lib; {
    description = "Python composable command line utility";
    homepage = "https://github.com/python-trio/asyncclick";
    changelog = "https://github.com/python-trio/asyncclick/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
