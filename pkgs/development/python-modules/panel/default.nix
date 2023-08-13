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
  version = "0.14.4";

  format = "wheel";

  # We fetch a wheel because while we can fetch the node
  # artifacts using npm, the bundling invoked in setup.py
  # tries to fetch even more artifacts
  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-3U/PL8cnbNPw3xEM56YZesQEDXTE79yMCSsjdxwfUU0=";
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
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
