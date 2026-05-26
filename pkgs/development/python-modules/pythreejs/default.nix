{
  lib,
  buildPythonPackage,
  fetchPypi,

  jupyterlab,
  setuptools,

  ipywidgets,
  ipydatawidgets,
  numpy,
  traitlets,
}:

buildPythonPackage rec {
  pname = "pythreejs";
  version = "2.4.2";
  pyproject = true;

  # github sources need to invoke npm, but no package-lock.json present:
  # https://github.com/jupyter-widgets/pythreejs/issues/419
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pWi/3Ew3l8TCM5FYko7cfc9vpKJnsI487FEh4geLW9Y=";
  };

  build-system = [
    jupyterlab
    setuptools
  ];

  # It seems pythonRelaxDeps doesn't work for these
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "jupyterlab~=" "jupyterlab>="

    # https://github.com/jupyter-widgets/pythreejs/pull/420
    substituteInPlace setupbase.py \
      --replace-fail "import pipes" "" \
      --replace-fail "pipes.quote" "shlex.quote"
  '';

  # Don't run npm install, all files are already where they should be present.
  # If we would run npm install, npm would detect package-lock.json is an old format,
  # and try to fetch more metadata from the registry, which cannot work in the sandbox.
  setupPyBuildFlags = [ "--skip-npm" ];

  dependencies = [
    ipywidgets
    ipydatawidgets
    numpy
    traitlets
  ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "pythreejs" ];

  meta = {
    description = "Interactive 3D graphics for the Jupyter Notebook and JupyterLab, using Three.js and Jupyter Widgets";
    homepage = "https://github.com/jupyter-widgets/pythreejs";
    changelog = "https://github.com/jupyter-widgets/pythreejs/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
