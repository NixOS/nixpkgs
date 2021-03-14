{ lib, stdenv, fetchurl, fetchpatch, libtool }:

stdenv.mkDerivation rec {
  pname = "libtomcrypt";
  version = "1.18.2";

  src = fetchurl {
    url = "https://github.com/libtom/libtomcrypt/releases/download/v${version}/crypt-${version}.tar.xz";
    sha256 = "113vfrgapyv72lalhd3nkw7jnks8az0gcb5wqn9hj19nhcxlrbcn";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-17362.patch";
      url = "https://github.com/libtom/libtomcrypt/pull/508/commits/25c26a3b7a9ad8192ccc923e15cf62bf0108ef94.patch";
      sha256 = "1bwsj0pwffxw648wd713z3xcyrbxc2z646psrzp38ys564fjh5zf";
    })
  ];

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

  meta = with lib; {
    homepage = "https://www.libtom.net/LibTomCrypt/";
    description = "A fairly comprehensive, modular and portable cryptographic toolkit";
    license = with licenses; [ publicDomain wtfpl ];
    platforms = platforms.linux;
  };
}
