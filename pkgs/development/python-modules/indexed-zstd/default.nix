{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  cython,
  zstd,
}:

buildPythonPackage rec {
  pname = "indexed_zstd";
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i3Q3j5Rh/OqxdSFbZeHEiYZN2zS9gWBYk2pifwzKOos=";
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

  meta = with lib; {
    description = "Python library to seek within compressed zstd files";
    homepage = "https://github.com/martinellimarco/indexed_zstd";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
