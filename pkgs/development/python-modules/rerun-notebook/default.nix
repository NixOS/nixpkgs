{
  buildPythonPackage,
  rerun,
  fetchPypi,

  # dependencies
  anywidget,
  ipykernel,
  jupyter-ui-poll,
}:

buildPythonPackage (finalAttrs: {
  pname = "rerun-notebook";
  inherit (rerun) version;
  format = "wheel";

  # Building this package from source is very cumbersome (it requires a wasm web-viewer
  # cross-compile via cargo + an npm/esbuild bundle). Using the upstream wheel for now.
  src = fetchPypi {
    pname = "rerun_notebook";
    inherit (finalAttrs) version;
    format = "wheel";
    python = "py2.py3";
    hash = "sha256-o21Ws8nP4BW7dF6w/lhDJKvdlMsvSMmfVyyK86Ccazc=";
  };

  pythonRelaxDeps = [
    # Upstream pins ipykernel<7.0.0 to dodge ipython/ipykernel#1450.
    "ipykernel"
  ];
  dependencies = [
    anywidget
    ipykernel
    jupyter-ui-poll
  ];

  pythonImportsCheck = [ "rerun_notebook" ];

  meta = {
    description = "Implementation helper for running rerun-sdk in notebooks";
    homepage = "https://github.com/rerun-io/rerun/tree/main/rerun_notebook";
    inherit (rerun.meta)
      changelog
      license
      maintainers
      ;
  };
})
