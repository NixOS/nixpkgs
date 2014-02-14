{stdenv, fetchgit, libgcrypt, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  name = "libotr-20130821-git-f0f8a2";
  src = fetchgit {
    url = "http://git.code.sf.net/p/otr/libotr";
    rev = "f0f8a2";
    sha256 = "08019r8bnk8f4yx6574jdz217p283ry7dmpqcad2d87yhkdmc3mm";
  };

  NIX_LDFLAGS = "-lssp";

  propagatedBuildInputs = [ libgcrypt autoconf automake libtool ];

  preConfigure = "autoreconf -vfi";

  meta = {
    homepage = "http://www.cypherpunks.ca/otr/";
    repositories.git = git://git.code.sf.net/p/otr/libotr;
    license = "LGPLv2.1";
    description = "Library for Off-The-Record Messaging";
  };
}
