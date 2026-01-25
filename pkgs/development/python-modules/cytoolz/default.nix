{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pytestCheckHook,
  cython,
  setuptools,
  setuptools-git-versioning,
  toolz,
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "1.1.0";
  pyproject = true;

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E6e/JUw8DSixLiKQuCrtDwl3pMKiv4SFT83HeWop87A=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [ toolz ];

  # tests are located in cytoolz/tests, but we need to prevent import from the cytoolz source
  preCheck = ''
    mv cytoolz/tests tests
    rm -rf cytoolz
    sed -i "/testpaths/d" pyproject.toml
  '';

  disabledTests = [
    # https://github.com/pytoolz/cytoolz/issues/200
    "test_inspect_wrapped_property"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = lib.licenses.bsd3;
  };
}
