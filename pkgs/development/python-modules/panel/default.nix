{
  lib,
  buildPythonPackage,
  fetchPypi,
  bleach,
  bokeh,
  param,
  pyviz-comms,
  markdown,
  pyct,
  requests,
  setuptools,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "panel";
  version = "1.4.4";

  format = "wheel";

  # We fetch a wheel because while we can fetch the node
  # artifacts using npm, the bundling invoked in setup.py
  # tries to fetch even more artifacts
  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-tJu5Z2VnsMBzC/aTSMBXJHCAgRrsVjZN1Pz7qA5eCaA=";
    dist = "py3";
    python = "py3";
  };


  pythonRelaxDeps = [ "bokeh" ];

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

  pythonImportsCheck = [ "panel" ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  meta = with lib; {
    description = "High level dashboarding library for python visualization libraries";
    mainProgram = "panel";
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
