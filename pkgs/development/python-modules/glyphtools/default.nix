{
  lib,
  buildPythonPackage,
  fetchPypi,
  beziers,
  glyphslib,
  numpy,
}:

buildPythonPackage rec {
  pname = "glyphtools";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PXwXHWMJbsi6ZtN+daaXAnlw3gV5DFAhyRxdBa7UP+M=";
  };

  propagatedBuildInputs = [
    beziers
    glyphslib
    numpy
  ];

  # A unit test suite does exist, but it only contains a dummy test that
  # imports the library.
  doCheck = false;

  pythonImportsCheck = [ "glyphtools" ];

  meta = {
    description = "Python library for extracting information from font glyphs";
    homepage = "https://github.com/simoncozens/glyphtools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
