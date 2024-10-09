{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  ipython,
}:

buildPythonPackage rec {
  pname = "jupyter-ui-poll";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Kirill888";
    repo = "jupyter-ui-poll";
    rev = "refs/tags/v${version}";
    hash = "sha256-mlgLd6uFDSxRBj4+Eidea2CE7FuG6NzJLWGec4KPd9k=";
  };

  build-system = [ setuptools ];

  dependencies = [ ipython ];

  doCheck = false; # no tests in package :(
  pythonImportsCheck = [ "jupyter_ui_poll" ];

  meta = {
    description = "Block jupyter cell execution while interacting with widgets";
    homepage = "https://github.com/Kirill888/jupyter-ui-poll";
    changelog = "https://github.com/Kirill888/jupyter-ui-poll/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
