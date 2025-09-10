{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  cython,
  zlib,
}:

buildPythonPackage rec {
  pname = "indexed_gzip";
  version = "1.9.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EFNmVndZ22x9+GbYaWEd7Tu4PVwOUPuwHQLBkiuYtFc=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  buildInputs = [ zlib ];

  # Too complicated to get to work, not a simple pytest call.
  doCheck = false;

  pythonImportsCheck = [ "indexed_gzip" ];

  meta = with lib; {
    description = "Python library to seek within compressed gzip files";
    homepage = "https://github.com/pauldmccarthy/indexed_gzip";
    license = licenses.zlib;
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
