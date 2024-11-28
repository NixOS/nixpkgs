{ lib
, stdenv
, fetchurl
, imake
, gccmakedep
, libX11
, libXaw
, libXext
, libXmu
, libXt
}:

stdenv.mkDerivation rec {
  pname = "xxgdb";
  version = "1.12";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/x/xxgdb/xxgdb_${version}.orig.tar.gz";
    sha256 = "0jwazg99wk2l7r390ggw0yr8xipl07bp0qynni141xss530i6d1a";
  };

  patches = [
    # http://zhu-qy.blogspot.com.es/2012/11/slackware-14-i-still-got-xxgdb-all-ptys.html
    ./xxgdb-pty.patch
  ];

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ libX11 libXaw libXext libXmu libXt ];

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
}
