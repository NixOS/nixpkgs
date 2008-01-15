args: with args;

stdenv.mkDerivation {
  name = "kdepimlibs-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdepimlibs-4.0.0.tar.bz2;
	sha256 = "0vixx2vh7qgysnbzvykf20362p22jzvl8snpqaknay3v3b2k0br0";
  };

  propagatedBuildInputs = [kdelibs boost gpgme cyrus_sasl openldap];
}
