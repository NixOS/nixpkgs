{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "libtomcrypt-1.17";

  src = fetchurl {
    url = "https://github.com/libtom/libtomcrypt/releases/download/1.17/crypt-1.17.tar.bz2";
    sha256 = "e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116";
  };

  buildInputs = [libtool];

  preBuild = ''
    makeFlagsArray=(LIBPATH=$out/lib INCPATH=$out/include \
      DATAPATH=$out/share/doc/libtomcrypt/pdf \
      INSTALL_GROUP=$(id -g) \
      INSTALL_USER=$(id -u))
  '';

  makefile = "makefile.shared";

  meta = {
    homepage = "http://libtom.org/?page=features&newsitems=5&whatfile=crypt";
    description = "A fairly comprehensive, modular and portable cryptographic toolkit";
    platforms = stdenv.lib.platforms.linux;
  };
}
