{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cython,
  setuptools,
  setuptools-git-versioning,
  toolz,
  python,
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E6e/JUw8DSixLiKQuCrtDwl3pMKiv4SFT83HeWop87A=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-git-versioning
  ];

  propagatedBuildInputs = [ toolz ];

  preCheck = ''
    cd $out/${python.sitePackages}
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = lib.licenses.bsd3;
  };
}
