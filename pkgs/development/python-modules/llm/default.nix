{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, numpy
, openai
, pydantic
, pytestCheckHook
, python-ulid
, pythonOlder
, pyyaml
, requests-mock
, sqlite-migrate
, sqlite-utils
}:

buildPythonPackage rec {
  pname = "llm";
  version = "0.12";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-aCqdw2co/cXrBwVY/k/aSLl3C22nlH5LvU2yir1/NnQ=";
  };

  propagatedBuildInputs = [
    click
    openai
    pydantic
    python-ulid
    pyyaml
    sqlite-migrate
    sqlite-utils
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "CLI utility and Python library for interacting with Large Language Models";
    homepage = "https://llm.datasette.io/";
    changelog = "https://github.com/simonw/llm/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
