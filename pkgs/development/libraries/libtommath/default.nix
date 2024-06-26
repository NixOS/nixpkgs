{
  lib,
  stdenv,
  fetchurl,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "libtommath";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/libtom/libtommath/releases/download/v${version}/ltm-${version}.tar.xz";
    sha256 = "sha256-KWJy2TQ1mRMI63NgdgDANLVYgHoH6CnnURQuZcz6nQg=";
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

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.isDarwin && stdenv.isAarch64
  ) "-DTARGET_OS_IPHONE=0";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.libtom.net/LibTomMath/";
    description = "Library for integer-based number-theoretic applications";
    license = with licenses; [
      publicDomain
      wtfpl
    ];
    platforms = platforms.unix;
  };
}
