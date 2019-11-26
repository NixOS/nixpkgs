{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, Babel
, lxml
}:

buildPythonPackage rec {
  pname = "babelgladeextractor";
  version = "0.6.0";

  src = fetchPypi {
    pname = "BabelGladeExtractor";
    inherit version;
    extension = "tar.bz2";
    sha256 = "18m5vi3sj2h26ibmb6fzfjs2lscg757ivk1bjgkn1haf9gdwyjj6";
  };

  propagatedBuildInputs = [
    Babel
    lxml # TODO: remove in 0.7.0
  ];

  # Tests missing
  # https://github.com/gnome-keysign/babel-glade/issues/5
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gnome-keysign/babel-glade";
    description = "Babel Glade XML files translatable strings extractor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
