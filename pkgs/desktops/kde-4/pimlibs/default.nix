args: with args;

stdenv.mkDerivation {
  name = "kdepimlibs-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdepimlibs-4.0.0.tar.bz2;
    md5 = "1a68662230fcd4ec8cea90bb780f920e";
  };

  propagatedBuildInputs = [kdelibs boost gpgme cyrus_sasl openldap];
}
