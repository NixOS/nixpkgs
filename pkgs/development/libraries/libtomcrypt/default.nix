{ stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  name = "libtomcrypt-${version}";
  version = "1.18.0";

  src = fetchurl {
    url = "https://github.com/libtom/libtomcrypt/releases/download/v${version}/crypt-${version}.tar.xz";
    sha256 = "0ymqi0zf5gzn8pq4mnylwgg6pskml2v1p9rsjrqspyja65mgb7fs";
  };

  nativeBuildInputs = [ libtool ];

  postPatch = ''
    substituteInPlace makefile.shared --replace "LT:=glibtool" "LT:=libtool"
  '';

  preBuild = ''
    makeFlagsArray=(PREFIX=$out \
      INSTALL_GROUP=$(id -g) \
      INSTALL_USER=$(id -u))
  '';

  makefile = "makefile.shared";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.libtom.net/LibTomCrypt/;
    description = "A fairly comprehensive, modular and portable cryptographic toolkit";
    license = with licenses; [ publicDomain wtfpl ];
    platforms = platforms.linux;
  };
}
