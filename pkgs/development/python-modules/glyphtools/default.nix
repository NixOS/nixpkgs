{
  lib,
  buildPythonPackage,
  fetchPypi,
  beziers,
  glyphslib,
  numpy,
  setuptoolsCheckHook,
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
  # doesn't test anything. It does import the module though so we still run it.
  doCheck = true;
  nativeCheckInputs = [
    # Upstream apparently prefers the deprecated setuptools 'test' command.
    setuptoolsCheckHook
  ];

  meta = with lib; {
    description = "Python library for extracting information from font glyphs";
    homepage = "https://github.com/simoncozens/glyphtools";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
