{
  lib,
  stdenv,
  fetchurl,
  imake,
  gccmakedep,
  libX11,
  libXaw,
  libXext,
  libXmu,
  libXt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xxgdb";
  version = "1.12";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/x/xxgdb/xxgdb_${finalAttrs.version}.orig.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  patches = [
    # http://zhu-qy.blogspot.com.es/2012/11/slackware-14-i-still-got-xxgdb-all-ptys.html
    ./xxgdb-pty.patch
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=implicit-int";

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libX11
    libXaw
    libXext
    libXmu
    libXt
  ];

  preConfigure = ''
    mkdir build
    xmkmf
  '';

  makeFlags = [
    "DESTDIR=build"
  ];

  postInstall = ''
    # Fix up install paths
    shopt -s globstar
    mv build/**/bin $out/bin

    install -D xxgdb.1 $out/share/man/man1/xxgdb.1
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Simple but powerful graphical interface to gdb";
    mainProgram = "xxgdb";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
})
