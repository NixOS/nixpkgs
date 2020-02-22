{ stdenv, buildPythonPackage, fetchPypi,
  m2r, setuptools_scm, six, attrs }:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "Automat";

  src = fetchPypi {
    inherit pname version;
    sha256 = "269a09dfb063a3b078983f4976d83f0a0d3e6e7aaf8e27d8df1095e09dc4a484";
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
