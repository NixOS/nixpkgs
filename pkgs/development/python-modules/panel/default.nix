{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  bokeh,
  linkify-it-py,
  markdown-it-py,
  markdown,
  mdit-py-plugins,
  narwhals,
  nh3,
  packaging,
  pandas,
  panel-material-ui,
  param,
  pyviz-comms,
  requests,
  tqdm,
  typing-extensions,

  withMaterialUi ? true,
}:

buildPythonPackage (finalAttrs: {
  pname = "panel";
  version = "1.10.0";
  format = "wheel";

  # We fetch a wheel because it contains ~75 pre-built javascript dependencies
  # pinned to specific versions (and included in their filenames).
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";
    hash = "sha256-Fcnyu1hWep42oiOWyzh3bfd+sMxSzZqZzrt4QksDY8A=";
    dist = "py3";
    python = "py3";
  };

  pythonRelaxDeps = [ "bokeh" ];

  pythonRemoveDeps = lib.optionals (!withMaterialUi) [ "panel-material-ui" ];

  dependencies = [
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
    pyviz-comms
    requests
    tqdm
    typing-extensions
  ]
  ++ lib.optionals withMaterialUi [ panel-material-ui ];

  pythonImportsCheck = [ "panel" ];

  # No tests in wheel
  doCheck = false;

  meta = {
    description = "High level dashboarding library for python visualization libraries";
    mainProgram = "panel";
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode # built python files
      fromSource # bundled javascript dependencies
    ];
    maintainers = with lib.maintainers; [
      locnide
      sarahec
    ];
  };
})
