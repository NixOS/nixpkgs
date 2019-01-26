{ stdenv, buildPythonPackage, fetchPypi,
  mistune, docutils } :
buildPythonPackage rec {
  pname = "m2r";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b64ee5ac870311a69967fe787be8607df67b02a329f0fc76c8bf477336a99c78";
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
