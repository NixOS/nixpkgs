{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  jupyter-builder,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyterlab-widgets";
  version = "3.0.17";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit (finalAttrs) version;
    hash = "sha256-bmH+IcqKZgORgKXMUqQz4HJ50v7nnIvpY+ANVRk/F6g=";
  };

  # jupyterlab is required to build from source but we use the pre-build package
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab~=4.0"' ""
  '';

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyter-builder
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab_widgets" ];

  meta = {
    description = "Jupyter Widgets JupyterLab Extension";
    homepage = "https://github.com/jupyter-widgets/ipywidgets";
    changelog = "https://github.com/jupyter-widgets/ipywidgets/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
