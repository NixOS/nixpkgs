args: with args;

stdenv.mkDerivation {
  name = "kdepimlibs-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdepimlibs-3.95.0.tar.bz2;
	sha256 = "1dhn5x3k9myqfymv6ry84v0zm2qwxnrlm1vdlllfvmgbm5nz34mg";
  };

  propagatedBuildInputs = [kdelibs boost gpgme cyrus_sasl openldap];
}
