{ stdenv, buildPythonPackage, fetchPypi,
  mistune, docutils } :
buildPythonPackage rec {
  pname = "m2r";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf90bad66cda1164b17e5ba4a037806d2443f2a4d5ddc9f6a5554a0322aaed99";
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
