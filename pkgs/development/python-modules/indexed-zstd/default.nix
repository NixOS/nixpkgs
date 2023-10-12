{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, zstd
}:

buildPythonPackage rec {
  pname = "indexed_zstd";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-icCerrv6ihBjSTS4Fsw7qhoA5ha8yegfMVRiIOhTvvY=";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [ zstd.dev ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "indexed_zstd" ];

  meta = with lib; {
    description = "Python library to seek within compressed zstd files";
    homepage = "https://github.com/martinellimarco/indexed_zstd";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
