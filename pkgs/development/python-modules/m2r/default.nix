{ stdenv, buildPythonPackage, fetchPypi,
  mistune, docutils } :
buildPythonPackage rec {
  pname = "m2r";
  name = "${pname}-${version}";
  version = "0.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adfb86ebb7ff3fcd3ebb27ce8cd6f795c409a13f0c03363e265f17419ce5b9ab";
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
