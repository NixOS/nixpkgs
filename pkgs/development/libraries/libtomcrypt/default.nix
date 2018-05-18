{ stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  name = "libtomcrypt-${version}";
  version = "1.18.1";

  src = fetchurl {
    url = "https://github.com/libtom/libtomcrypt/releases/download/v${version}/crypt-${version}.tar.xz";
    sha256 = "053z0jzyvf6c9929phlh2p0ybx289s34g7nii5hnjigxzcs3mhap";
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
