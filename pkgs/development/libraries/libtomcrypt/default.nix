{ stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  pname = "libtomcrypt";
  version = "1.18.2";

  src = fetchurl {
    url = "https://github.com/libtom/libtomcrypt/releases/download/v${version}/crypt-${version}.tar.xz";
    sha256 = "113vfrgapyv72lalhd3nkw7jnks8az0gcb5wqn9hj19nhcxlrbcn";
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
    homepage = https://www.libtom.net/LibTomCrypt/;
    description = "A fairly comprehensive, modular and portable cryptographic toolkit";
    license = with licenses; [ publicDomain wtfpl ];
    platforms = platforms.linux;
  };
}
