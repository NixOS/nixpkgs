{ stdenv
, lib
, isPy3k
, buildPythonPackage
, fetchPypi
, Babel
}:

buildPythonPackage rec {
  pname = "babelgladeextractor";
  version = "0.6.3";

  src = fetchPypi {
    pname = "BabelGladeExtractor";
    inherit version;
    extension = "tar.bz2";
    sha256 = "12i2i97wai5vv5h522rj6pfcdsfyrkgmjqc699m5v4af0yy3rqsq";
  };

  propagatedBuildInputs = [
    Babel
  ];

  # SyntaxError: Non-ASCII character '\xc3' in file /build/BabelGladeExtractor-0.6.3/babelglade/tests/test_translate.py on line 20, but no encoding declared; see http://python.org/dev/peps/pep-0263/ for details
  doCheck = isPy3k;

  meta = with lib; {
    homepage = "https://github.com/gnome-keysign/babel-glade";
    description = "Babel Glade XML files translatable strings extractor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
