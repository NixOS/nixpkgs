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
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "async_interrupt";
    rev = "refs/tags/v${version}";
    hash = "sha256-opV5h3aLDDpjlRZRZ9OnrPjUOf/i7g+B9T6msk8wtgI=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "async_interrupt" ];

  meta = with lib; {
    description = "Context manager to raise an exception when a future is done";
    homepage = "https://github.com/bdraco/async_interrupt";
    changelog = "https://github.com/bdraco/async_interrupt/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
