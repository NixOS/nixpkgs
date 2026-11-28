{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  zstd,
}:

buildPythonPackage rec {
  pname = "indexed_zstd";
  version = "1.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NquKQwJqPDWU4NlnhplMP5tMBAOdlS3y+twf1Upll7A=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  buildInputs = [ zstd.dev ];

  postPatch = "cython -3 --cplus indexed_zstd/indexed_zstd.pyx";

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "indexed_zstd" ];

  meta = {
    description = "Python library to seek within compressed zstd files";
    homepage = "https://github.com/martinellimarco/indexed_zstd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
