{ stdenv, fetchgit, xorgproto, libX11, bison, ksh, perl, gnum4
, libXinerama, libXt, libXext, libtirpc, motif, libXft, xbitmaps
, libjpeg, libXmu, libXdmcp, libXScrnSaver, symlinkJoin, bdftopcf
, ncompress, mkfontdir, tcl, libXaw, gcc, glibcLocales, gawk
, autoPatchelfHook, libredirect, makeWrapper, xset, xrdb, fakeroot }:

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
  version = "2019-11-30";
  name = "cde-${version}";

  src = fetchgit {
    url = "https://git.code.sf.net/p/cdesktopenv/code";
    rev = "5cebd7c4da1afea353a3baef250e31a4cf867bc5";
    sha256 = "06wvnb3n8hn98kxvmrf6v3lyqp8bxpzl8wrixlw9jinmsivfs4b9";
  };
  setSourceRoot = ''export sourceRoot="$(echo */cde)"'';

  buildInputs = [
    libX11 libXinerama libXt libXext libtirpc motif libXft xbitmaps
    libjpeg libXmu libXdmcp libXScrnSaver tcl libXaw ksh
  ];
  nativeBuildInputs = [
    bison ncompress gawk autoPatchelfHook makeWrapper fakeroot
  ];

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

  meta = with stdenv.lib; {
    description = "Common Desktop Environment";
    homepage = https://sourceforge.net/projects/cdesktopenv/;
    license = licenses.lgpl2;
    maintainers = [ maintainers.gnidorah ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
