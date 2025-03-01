{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  numpy,
  setuptools,

  # native dependencies
  openmp,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EISP9qxzMraOZb+MLolme2tisHWq0nI0d0Smm/HIrX4=";
  };

  nativeBuildInputs = [
    cython
    numpy
    setuptools
  ];

  buildInputs = [ openmp ];

  propagatedBuildInputs = [ numpy ];

  preCheck = ''
    # make sure we don't import pykdtree from the source tree
    mv pykdtree/test_tree.py .
    rm -rf pykdtree
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "kd-tree implementation for fast nearest neighbour search in Python";
    homepage = "https://github.com/storpipfugl/pykdtree";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
