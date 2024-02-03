{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, zlib
}:

buildPythonPackage rec {
  pname = "indexed_gzip";
  version = "1.8.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h9JgYq9KxmknaRuMgq+5YWA8tUaFk+lclkqdNAnr/cI=";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [ zlib ];

  # Too complicated to get to work, not a simple pytest call.
  doCheck = false;

  pythonImportsCheck = [ "indexed_gzip" ];

  meta = with lib; {
    description = "Python library to seek within compressed gzip files";
    homepage = "https://github.com/pauldmccarthy/indexed_gzip";
    license = licenses.zlib;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
