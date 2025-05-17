{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-madvr2";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iloveicedgreentea";
    repo = "py-madvr";
    tag = "v${version}";
    hash = "sha256-tZaQlu59s7AuVHnoyoFc6VGgc85q4r9TRMl6KxdPdrA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "madvr" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/iloveicedgreentea/py-madvr/issues/16
    "test_async_add_tasks"
    "test_send_heartbeat"
  ];

  meta = {
    changelog = "https://github.com/iloveicedgreentea/py-madvr/releases/tag/${src.tag}";
    description = "Control MadVR Envy over IP";
    homepage = "https://github.com/iloveicedgreentea/py-madvr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
