{ lib, buildPythonPackage, fetchPypi,
  m2r, setuptools-scm, six, attrs }:

buildPythonPackage rec {
  version = "20.2.0";
  pname = "Automat";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7979803c74610e11ef0c0d68a2942b152df52da55336e0c9d58daf1831cbdf33";
  };

  buildInputs = [ m2r setuptools-scm ];
  propagatedBuildInputs = [ six attrs ];

  # Some tests require twisetd, but twisted requires Automat to build.
  # this creates a circular dependency.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/glyph/Automat";
    description = "Self-service finite-state machines for the programmer on the go";
    license = licenses.mit;
    maintainers = [ ];
  };
}
