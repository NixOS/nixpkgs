{ lib, stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  pname = "libtommath";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/libtom/libtommath/releases/download/v${version}/ltm-${version}.tar.xz";
    sha256 = "sha256-mGAl17N0J2/uLjDpnzZJ5KwNuKAiV6N+4Q6ucqvtDR8=";
  };

  nativeBuildInputs = [ libtool ];

  postPatch = ''
    substituteInPlace makefile.shared --replace glibtool libtool
    substituteInPlace makefile_include.mk --replace "shell arch" "shell uname -m"
  '';

  preBuild = ''
    makeFlagsArray=(PREFIX=$out \
      INSTALL_GROUP=$(id -g) \
      INSTALL_USER=$(id -u))
  '';

  makefile = "makefile.shared";

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) "-DTARGET_OS_IPHONE=0";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.libtom.net/LibTomMath/";
    description = "A library for integer-based number-theoretic applications";
    license = with licenses; [ publicDomain wtfpl ];
    platforms = platforms.unix;
  };
}
