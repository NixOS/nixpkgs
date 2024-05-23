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
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Kirill888";
    repo = "jupyter-ui-poll";
    rev = "refs/tags/v${version}";
    hash = "sha256-DWZFvzx0aNTmf1x8Rq19OT0PFRxdpKefWYFh8C116Fw";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ ipython ];

  doCheck = false; # no tests in package :(
  pythonImportsCheck = [ "jupyter_ui_poll" ];

  meta = with lib; {
    description = "Block jupyter cell execution while interacting with widgets";
    homepage = "https://github.com/Kirill888/jupyter-ui-poll";
    changelog = "https://github.com/Kirill888/jupyter-ui-poll/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
