{
  lib,
  isPy3k,
  buildPythonPackage,
  fetchPypi,
  babel,
}:

buildPythonPackage rec {
  pname = "babelgladeextractor";
  version = "0.7.0";
  format = "setuptools";
  disabled = (!isPy3k); # uses python3 specific file io in setup.py

  src = fetchPypi {
    pname = "BabelGladeExtractor";
    inherit version;
    extension = "tar.bz2";
    sha256 = "160p4wi2ss69g141c2z59azvrhn7ymy5m9h9d65qrcabigi0by5w";
  };

  propagatedBuildInputs = [ babel ];

  # SyntaxError: Non-ASCII character '\xc3' in file /build/BabelGladeExtractor-0.6.3/babelglade/tests/test_translate.py on line 20, but no encoding declared; see http://python.org/dev/peps/pep-0263/ for details
  doCheck = isPy3k;

  meta = with lib; {
    homepage = "https://github.com/gnome-keysign/babel-glade";
    description = "Babel Glade XML files translatable strings extractor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
