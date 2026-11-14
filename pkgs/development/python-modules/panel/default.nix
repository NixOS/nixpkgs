{
  lib,
  buildPythonPackage,
  fetchPypi,
  bleach,
  bokeh,
  linkify-it-py,
  markdown,
  markdown-it-py,
  mdit-py-plugins,
  narwhals,
  nh3,
  packaging,
  pandas,
  panel-material-ui,
  param,
  pyviz-comms,
  pyct,
  pythonOlder,
  requests,
  setuptools,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "panel";
  version = "1.10.0";

  disabled = pythonOlder "3.12";

  format = "wheel";

  # We fetch a wheel because while we can fetch the node
  # artifacts using npm, the bundling invoked in setup.py
  # tries to fetch even more artifacts
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    hash = "sha256-Fcnyu1hWep42oiOWyzh3bfd+sMxSzZqZzrt4QksDY8A=";
    dist = "py3";
    python = "py3";
  };

  pythonRelaxDeps = [ "bokeh" ];

  # There is a cycle between panel and panel-material-ui.
  # panel-material-ui is only needed for the ``panel.ui`` namespace.
  # We break the cycle by making panel-material-ui an optional dependency of panel.
  pythonRemoveDeps = [ "panel-material-ui" ];

  optional-dependencies = {
    material-ui = [ panel-material-ui ];
  };

  propagatedBuildInputs = [
    bleach
    bokeh
    linkify-it-py
    markdown
    markdown-it-py
    mdit-py-plugins
    narwhals
    nh3
    packaging
    pandas
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

  meta = {
    description = "High level dashboarding library for python visualization libraries";
    mainProgram = "panel";
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      locnide
      charmoniumQ
    ];
  };
}
