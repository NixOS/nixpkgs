{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  jupyter-packaging,
  jupyterlab,
  setuptools,

  # dependencies
  ipywidgets,
  lz4,
  numpy,
  pandas,
  traitlets,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ipytablewidgets";
  version = "0.3.4";
  pyproject = true;
  __structuredAttrs = true;

  # The GitHub tarball does not ship the pre-built labextension assets, which
  # `jupyter_packaging` requires at build time. Only the sdist does.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ni4933km+meObT131hsPWBckhBwjZBbQVG0iepNxjRk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "setuptools>=40.8.0,<80" \
        "setuptools"
  '';

  build-system = [
    jupyter-packaging
    jupyterlab
    setuptools
  ];

  dependencies = [
    ipywidgets
    lz4
    numpy
    pandas
    traitlets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ipytablewidgets" ];

  meta = {
    description = "Traitlets and widgets to efficiently data tables (e.g. Pandas DataFrame) using the jupyter notebook";
    homepage = "https://github.com/progressivis/ipytablewidgets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
