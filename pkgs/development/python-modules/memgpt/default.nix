{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, questionary
, typer
, rich
, prettytable
, colorama
, demjson3
, pytz
, tiktoken
, pyyaml
, docstring-parser
, python-box
, llama-index
}:

buildPythonPackage rec {
  pname = "memgpt";
  version = "0.2.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cpacker";
    repo = "MemGPT";
    rev = "refs/tags/${version}";
    hash = "sha256-/6gCeAYprhKG46ZAXWOfmwMw0z+lA2u6+e8eRNIRA2E=";
  };

  # True if tests
  doCheck = false;
  nativeBuildInputs = [ python.pkgs.poetry-core ];

  propagatedBuildInputs = with python.pkgs; [
    questionary
    typer
    rich
    prettytable
    colorama
    demjson3
    pytz
    tiktoken
    pyyaml
    docstring-parser
    python-box
    llama-index
  ];
}
