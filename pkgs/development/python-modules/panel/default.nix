{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, bleach
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, requests
, setuptools
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "panel";
  version = "1.3.8";

  format = "wheel";

  # We fetch a wheel because while we can fetch the node
  # artifacts using npm, the bundling invoked in setup.py
  # tries to fetch even more artifacts
  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-Sb85MZhqDd8/e0vaPGXGoxHVJ3UkrNtOC/9py6a/V3U=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "bokeh"
  ];

  propagatedBuildInputs = [
    bleach
    bokeh
    markdown
    param
    pyct
    pyviz-comms
    requests
    setuptools
    tqdm
    typing-extensions
  ];

  pythonImportsCheck = [
    "panel"
  ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    mainProgram = "panel";
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
