{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "118";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "refs/tags/v${version}";
    hash = "sha256-CbV/LGj09TfLYvaVGr2+LV76DRkz0kw7qsGbtL5A45g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=pydeconz --cov-report term-missing" "" \
      --replace-fail "setuptools==" "setuptools>=" \
      --replace-fail "wheel==" "wheel>="
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydeconz" ];

  meta = with lib; {
    description = "Python library wrapping the Deconz REST API";
    homepage = "https://github.com/Kane610/deconz";
    changelog = "https://github.com/Kane610/deconz/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pydeconz";
  };
}
