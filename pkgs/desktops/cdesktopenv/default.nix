{ lib, stdenv, fetchurl
<<<<<<< HEAD
, libX11, bison, ksh, perl
, libXinerama, libXt, libXext, libtirpc, motif, libXft, xbitmaps
, libjpeg, libXmu, libXdmcp, libXScrnSaver, bdftopcf
, ncompress, mkfontdir, tcl, libXaw, libxcrypt, glibcLocales
, autoPatchelfHook, makeWrapper, xset, xrdb
, autoreconfHook, opensp, flex, libXpm
, rpcsvc-proto }:

stdenv.mkDerivation rec {
  pname = "cde";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/cdesktopenv/cde-${version}.tar.gz";
    hash = "sha256-caslezz2kbljwApv5igDPH345PK2YqQUTi1YZgvM1Dw=";
  };

  postPatch = ''
    for f in $(find . -type f ! -path doc/common); do
      sed -i \
        -e "s|/usr/dt|$out|g" \
        -e "s|/etc/dt|$out/etc|g" \
        -e "s|\$(DESTDIR)/var|$out/var|g" \
        "$f"
    done

    for f in $(find . -type f -name "Makefile.am"); do
      sed -i \
        -e "/chown /d" \
        -e "/chgrp /d" \
        -e "s/chmod 4755/chmod 755/g" \
        "$f"
    done

    substituteInPlace configure.ac \
      --replace "-I/usr/include/tirpc" "-I${libtirpc.dev}/include/tirpc"

    patchShebangs autogen.sh config.rpath contrib programs
  '';
=======
, fetchpatch
, xorgproto, libX11, bison, ksh, perl, gnum4
, libXinerama, libXt, libXext, libtirpc, motif, libXft, xbitmaps
, libjpeg, libXmu, libXdmcp, libXScrnSaver, symlinkJoin, bdftopcf
, ncompress, mkfontdir, tcl, libXaw, libxcrypt, gcc, glibcLocales
, autoPatchelfHook, libredirect, makeWrapper, xset, xrdb, fakeroot
, rpcsvc-proto }:

let
  x11ProjectRoot = symlinkJoin {
    name = "x11ProjectRoot";
    paths = [
      bdftopcf mkfontdir
      xset # fonts
      xrdb # session load
    ];
  };
in stdenv.mkDerivation rec {
  version = "2.3.2";
  pname = "cde";

  src = fetchurl {
    url = "mirror://sourceforge/cdesktopenv/cde-${version}.tar.gz";
    sha256 = "029rljhi5r483x8rzdpl8625z0wx8r7k2m0364nbw66h5pig9lbx";
  };

  # remove with next release
  patches = [
    ./2.3.2.patch
    ./0001-all-remove-deprecated-sys_errlist-and-replace-with-A.patch

    (fetchpatch {
      name = "binutils-2.36.patch";
      url = "https://github.com/cdesktopenv/cde/commit/0b7849e210a99a413ddeb52a0eb5aef9a08504a0.patch";
      sha256 = "0wlhs617hws3rwln9v74y1nw27n3pp7jkpnxlala7k5y64506ipj";
      stripLen = 1;
    })
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    libX11 libXinerama libXt libXext libtirpc motif libXft xbitmaps
    libjpeg libXmu libXdmcp libXScrnSaver tcl libXaw ksh libxcrypt
<<<<<<< HEAD
    libXpm
  ];
  nativeBuildInputs = [
    bison ncompress autoPatchelfHook makeWrapper
    autoreconfHook bdftopcf mkfontdir xset xrdb opensp perl flex
    rpcsvc-proto
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
  ];

  preInstall = ''
    mkdir -p $out/opt/dt/bin
=======
  ];
  nativeBuildInputs = [
    bison ncompress autoPatchelfHook makeWrapper fakeroot
    rpcsvc-proto
  ];
  # build fails otherwise
  enableParallelBuilding = false;

  # Workaround build failure on -fno-common toolchains:
  #   ld: raima/startup.o:/build/cde-2.3.2/lib/DtSearch/raima/dbtype.h:408: multiple definition of
  #     `__SK__'; raima/alloc.o:/build/cde-2.3.2/lib/DtSearch/raima/dbtype.h:408: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  makeFlags = [
    "World"
    "BOOTSTRAPCFLAGS=-I${xorgproto}/include/X11"
    "IMAKECPP=cpp"
    "LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
  ];

  preConfigure = ''
    # binutils 2.37 fix
    fixupList=(
      "config/cf/Imake.tmpl"
      "config/util/crayar.sh"
      "config/util/crayar.sh"
      "programs/dtwm/Makefile.tmpl"
    )
    for toFix in "''${fixupList[@]}"; do
      substituteInPlace "$toFix" --replace "clq" "cq"
    done
  '';

  preBuild = ''
    while IFS= read -r -d ''$'\0' i; do
      substituteInPlace "$i" --replace /usr/dt $out/opt/dt
    done < <(find "." -type f -exec grep -Iq /usr/dt {} \; -and -print0)

    cat >> config/cf/site.def << EOF
#define MakeFlagsToShellFlags(makeflags,shellcmd) set -e
#define KornShell ${ksh}/bin/ksh
#define PerlCmd ${perl}/bin/perl
#define M4Cmd ${gnum4}/bin/m4
#define X11ProjectRoot ${x11ProjectRoot}
#define CppCmd ${gcc}/bin/cpp
TIRPCINC = -I${libtirpc.dev}/include/tirpc
EOF

    patchShebangs .
    unset AR
  '';

  installPhase = ''
    fakeroot admin/IntegTools/dbTools/installCDE -s . -DontRunScripts

    mkdir -p $out/bin
    mv $out/opt/dt/bin/dtmail $out/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Common Desktop Environment";
    homepage = "https://sourceforge.net/projects/cdesktopenv/";
    license = licenses.lgpl2;
    maintainers = [ ];
<<<<<<< HEAD
    platforms = platforms.linux;
=======
    platforms = [ "i686-linux" "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
