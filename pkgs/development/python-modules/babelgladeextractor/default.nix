{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, Babel
}:

buildPythonPackage rec {
  pname = "babelgladeextractor";
  version = "0.6.1";

  src = fetchPypi {
    pname = "BabelGladeExtractor";
    inherit version;
    extension = "tar.bz2";
    sha256 = "1jhs12pliz54dbnigib1h8ywfzsj1g32c1vhspvg46f5983nvf93";
  };

  propagatedBuildInputs = [
    Babel
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
