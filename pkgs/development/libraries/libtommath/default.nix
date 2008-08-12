{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "libtommath-0.39";
  
  src = fetchurl {
    url = http://math.libtomcrypt.com/files/ltm-0.39.tar.bz2;
    sha256 = "1kjx8rrw62nanzc5qp8fj6r3ybhw8ca60ahkyb70f10aiij49zs2";
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
  };
}
