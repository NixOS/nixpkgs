{
  stdenv,
  lib,
  libiconv,
  fetchurl,
  m4,
  expat,
  libX11,
  libXt,
  libXaw,
  libXmu,
  bdftopcf,
  mkfontdir,
  fontadobe100dpi,
  fontadobeutopia100dpi,
  fontbh100dpi,
  fontbhlucidatypewriter100dpi,
  fontbitstream100dpi,
  tcl,
  ncurses,
  openssl,
  python3,
  readline,
}:
let
  majorVersion = "4";
  minorVersion = "4";
  versionSuffix = "ga6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "x3270";
  version = "${majorVersion}.${minorVersion}${versionSuffix}";

  src = fetchurl {
    url = "http://x3270.bgp.nu/download/0${majorVersion}.0${minorVersion}/suite3270-${finalAttrs.version}-src.tgz";
    hash = "sha256-hDju5ZeVzTv78ZYwUzabmqMK9rheTZJ7clTSTpkkM7E=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildFlags = lib.optional stdenv.hostPlatform.isLinux "unix";

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--enable-c3270"
    "--enable-pr3270"
    "--enable-s3270"
    "--enable-tcl3270"
  ];

  preBuild = ''
    if [ -n "$SOURCE_DATE_EPOCH" ]; then
      export SOURCE_DATE_EPOCH="$(date -u -d "@$SOURCE_DATE_EPOCH" '+%a %b %d %H:%M:%S UTC %Y')"
    fi
  '';

  postBuild = ''
    make install.man
  '';

  pathsToLink = [ "/share/man" ];

  nativeBuildInputs = [
    m4
    python3
  ];
  buildInputs = [
    expat
    libX11
    libXt
    libXaw
    libXmu
    bdftopcf
    mkfontdir
    fontadobe100dpi
    fontadobeutopia100dpi
    fontbh100dpi
    fontbhlucidatypewriter100dpi
    fontbitstream100dpi
    tcl
    ncurses
    expat
    openssl
    readline
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "IBM 3270 terminal emulator for the X Window System";
    homepage = "https://x3270.bgp.nu/index.html";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.anna328p ];
  };
})
