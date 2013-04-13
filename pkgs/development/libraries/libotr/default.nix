{stdenv, fetchurl, libgcrypt}:

stdenv.mkDerivation rec {
  name = "libotr-4.0.0";
  src = fetchurl {
    urls = [
      "http://www.cypherpunks.ca/otr/${name}.tar.gz"
      # The site is down at the time of updating to 4.0.0, so I add this url
      http://ftp.de.debian.org/debian/pool/main/libo/libotr/libotr_4.0.0.orig.tar.gz
    ];
    sha256 = "3f911994409898e74527730745ef35ed75c352c695a1822a677a34b2cf0293b4";
  };

  NIX_LDFLAGS = "-lssp";

  propagatedBuildInputs = [ libgcrypt ];

  meta = {
    homepage = "http://www.cypherpunks.ca/otr/";
    license = "LGPLv2.1";
    description = "Library for Off-The-Record Messaging";
  };
}
