{ stdenv, buildPythonPackage, fetchPypi,
  mistune, docutils } :
buildPythonPackage rec {
  pname = "m2r";
  name = "${pname}-${version}";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b19e3703a3a897859f01ff6a068ee9a0eea8e8fdf75e896e00e88b3476a12f87";
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
