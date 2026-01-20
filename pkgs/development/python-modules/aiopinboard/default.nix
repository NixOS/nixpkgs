{
  lib,
  aiohttp,
  aresponses,
  arrow,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  frozenlist,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiopinboard";
  version = "2024.01.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aiopinboard";
    tag = version;
    hash = "sha256-/N9r17e0ZvPmcqW/XtRyAENKCGRzWqeOSKPpWHHYomg=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    arrow
    certifi
    frozenlist
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopinboard" ];

  meta = {
    description = "Library to interact with the Pinboard API";
    homepage = "https://github.com/bachya/aiopinboard";
    changelog = "https://github.com/bachya/aiopinboard/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
