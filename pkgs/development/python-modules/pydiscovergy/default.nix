{ lib
, authlib
, buildPythonPackage
, fetchFromGitHub
, httpx
, mashumaro
, orjson
, pytest-httpx
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, pytz
, respx
}:

buildPythonPackage rec {
  pname = "pydiscovergy";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "pydiscovergy";
    rev = "refs/tags/v${version}";
    hash = "sha256-ArcH/4ZyOtIGmoXArU+oEd357trJnS9umlN9B+U0dBI=";
  };

  postPatch = ''
    sed -i '/addopts =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    authlib
    httpx
    mashumaro
    orjson
    pytz
  ];

  nativeCheckInputs = [
    pytest-httpx
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "pydiscovergy"
  ];

  meta = with lib; {
    description = "Async Python 3 library for interacting with the Discovergy API";
    homepage = "https://github.com/jpbede/pydiscovergy";
    changelog = "https://github.com/jpbede/pydiscovergy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
