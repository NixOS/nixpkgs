{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "async-interrupt";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "async_interrupt";
    tag = "v${version}";
    hash = "sha256-M0ftyHstBP7+6M2b6yV33mSuO4B8QF3ixRvNJ/WeSEA=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "async_interrupt" ];

  meta = with lib; {
    description = "Context manager to raise an exception when a future is done";
    homepage = "https://github.com/bdraco/async_interrupt";
    changelog = "https://github.com/bdraco/async_interrupt/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
