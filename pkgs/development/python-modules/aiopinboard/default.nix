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
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiopinboard";
  version = "2024.01.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

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

<<<<<<< HEAD
  meta = {
    description = "Library to interact with the Pinboard API";
    homepage = "https://github.com/bachya/aiopinboard";
    changelog = "https://github.com/bachya/aiopinboard/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to interact with the Pinboard API";
    homepage = "https://github.com/bachya/aiopinboard";
    changelog = "https://github.com/bachya/aiopinboard/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
