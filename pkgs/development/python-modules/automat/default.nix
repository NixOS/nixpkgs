{ stdenv, buildPythonPackage, fetchPypi,
  m2r, setuptools_scm, six, attrs }:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "Automat";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbd78b83fa2d81fe2a4d23d258e1661dd7493c9a50ee2f1a5b2cac61c1793b0e";
  };

  buildInputs = [ m2r setuptools_scm ];
  propagatedBuildInputs = [ six attrs ];

  # Some tests require twisetd, but twisted requires Automat to build.
  # this creates a circular dependency.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/glyph/Automat;
    description = "Self-service finite-state machines for the programmer on the go";
    license = licenses.mit;
    maintainers = [ ];
  };
}
