{ stdenv, buildPythonPackage, fetchPypi,
  mistune, docutils } :
buildPythonPackage rec {
  pname = "m2r";
  name = "${pname}-${version}";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "771631d051a52764fe5b660f97ad028df3aff90c9859d345ccfd17a4c7c2ab39";
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
