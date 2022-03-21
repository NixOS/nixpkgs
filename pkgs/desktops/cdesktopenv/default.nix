{ lib, stdenv, fetchurl
, fetchpatch
, xorgproto, libX11, bison, ksh, perl, gnum4
, libXinerama, libXt, libXext, libtirpc, motif, libXft, xbitmaps
, libjpeg, libXmu, libXdmcp, libXScrnSaver, symlinkJoin, bdftopcf
, ncompress, mkfontdir, tcl, libXaw, gcc, glibcLocales, gawk
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

  buildInputs = [
    libX11 libXinerama libXt libXext libtirpc motif libXft xbitmaps
    libjpeg libXmu libXdmcp libXScrnSaver tcl libXaw ksh
  ];
  nativeBuildInputs = [
    bison ncompress gawk autoPatchelfHook makeWrapper fakeroot
    rpcsvc-proto
  ];
  # build fails otherwise
  enableParallelBuilding = false;

  makeFlags = [
    "World"
    "BOOTSTRAPCFLAGS=-I${xorgproto}/include/X11"
    "IMAKECPP=cpp"
    "LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
  ];

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
  '';

  meta = with lib; {
    description = "Common Desktop Environment";
    homepage = "https://sourceforge.net/projects/cdesktopenv/";
    license = licenses.lgpl2;
    maintainers = [ ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
