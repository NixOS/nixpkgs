{ stdenv, buildPythonPackage, fetchurl,
  mistune, docutils } :
buildPythonPackage rec {
  name = "m2r-${version}";
  version = "0.1.5";

  src = fetchurl {
    url = "mirror://pypi/m/m2r/${name}.tar.gz";
    sha256 = "08rjn3x1qag60wawjnq95wmgijrn33apr4fhj01s2p6hmrqgfj1l";
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
