{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "libtommath-1.0";
  
  src = fetchurl {
    url = https://github.com/libtom/libtommath/releases/download/v1.0/ltm-1.0.tar.xz;
    sha256 = "0v5mpd8zqjfs2hr900w1mxifz23xylyjdqyx1i1wl7q9xvwpsflr";
  };

  buildInputs = [libtool];

  preBuild = ''
    makeFlagsArray=(LIBPATH=$out/lib INCPATH=$out/include \
      DATAPATH=$out/share/doc/libtommath/pdf \
      INSTALL_GROUP=$(id -g) \
      INSTALL_USER=$(id -u))
  '';

  makefile = "makefile.shared";

  meta = {
    homepage = http://math.libtomcrypt.com/;
    description = "A library for integer-based number-theoretic applications";
    platforms = stdenv.lib.platforms.unix;
  };
}
