{ stdenv, buildPythonPackage, fetchPypi,
  mistune, docutils } :
buildPythonPackage rec {
  pname = "m2r";
  name = "${pname}-${version}";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e69fe9b2752926c33399709e354da3bcca60043c7bf5e727b7126ec3a5db7db";
  };

  propagatedBuildInputs = [ mistune docutils ];

  # Some tests interfeere with each other (test.md and test.rst are
  # deleted by some tests and not properly regenerated)
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/miyakogi/m2r;
    description = "converts a markdown file including reST markups to a valid reST format";
    license = licenses.mit;
    maintainers = [ ];
  };
}
