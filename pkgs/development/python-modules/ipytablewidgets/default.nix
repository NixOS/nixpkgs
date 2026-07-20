{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  ipywidgets,
  jupyter-packaging,
  jupyterlab,
  lz4,
  numpy,
  pandas,
  setuptools,
  traitlets,
}:

buildPythonPackage rec {
  pname = "ipytablewidgets";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CGkb//mLUmkyv+hmVJX5+04JGCfw+TtfBxMTXW0bhsw=";
  };

  # Opened https://github.com/progressivis/ipytablewidgets/issues/3 to ask if
  # jupyterlab can be updated upstream. (From commits, it looks like it was
  # set to this version on purpose.) In the meantime, the build still works.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jupyterlab>=3.0.0,<3.7' 'jupyterlab>=3.0.0'
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
}
