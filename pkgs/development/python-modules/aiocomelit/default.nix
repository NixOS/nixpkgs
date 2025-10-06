{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  pint,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiocomelit";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    tag = "v${version}";
    hash = "sha256-/loKnKmLF8EDuZVWdSgxQUslrTKU4DxNmJlFZ0Xv9v8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    colorlog
    pint
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiocomelit" ];

  meta = with lib; {
    description = "Library to control Comelit Simplehome";
    homepage = "https://github.com/chemelli74/aiocomelit";
    changelog = "https://github.com/chemelli74/aiocomelit/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
