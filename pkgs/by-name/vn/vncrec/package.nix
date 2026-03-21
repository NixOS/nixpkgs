{
  lib,
  stdenv,
  fetchurl,
  libx11,
  xorgproto,
  imake,
  gccmakedep,
  libxt,
  libxmu,
  libxaw,
  libxext,
  libsm,
  libice,
  libxpm,
  libxp,
}:

stdenv.mkDerivation {
  pname = "vncrec";
  version = "0.2"; # version taken from Arch AUR

  src = fetchurl {
    url = "http://ronja.twibright.com/utils/vncrec-twibright.tgz";
    sha256 = "1yp6r55fqpdhc8cgrgh9i0mzxmkls16pgf8vfcpng1axr7cigyhc";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace vncpasswd/vncpasswd.c \
      --replace-fail "return;" "return 0;"

    sed -i '7i #include <stdlib.h>' vncconnect/vncconnect.c
    sed -i '8i #include <string.h>' vncconnect/vncconnect.c
    sed -i '31i #include <time.h>' libvncauth/vncauth.c
  '';

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libx11
    xorgproto
    libxt
    libxmu
    libxaw
    libxext
    libsm
    libice
    libxpm
    libxp
  ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man"
  ];
  installTargets = [
    "install"
    "install.man"
  ];

  meta = {
    description = "VNC recorder";
    homepage = "http://ronja.twibright.com/utils/vncrec/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    mainProgram = "vncrec";
  };
}
