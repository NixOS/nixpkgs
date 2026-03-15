{
  stdenv,
  lib,
  libiconv,
  fetchurl,
  m4,
  expat,
  libx11,
  libxt,
  libxaw,
  libxmu,
  bdftopcf,
  mkfontdir,
  font-adobe-100dpi,
  font-adobe-utopia-100dpi,
  font-bh-100dpi,
  font-bh-lucidatypewriter-100dpi,
  font-bitstream-100dpi,
  tcl,
  ncurses,
  openssl,
  python3,
  readline,
}:
let
  majorVersion = "4";
  minorVersion = "5";
  versionSuffix = "ga5";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "x3270";
  version = "${majorVersion}.${minorVersion}${versionSuffix}";

  src = fetchurl {
    url = "http://x3270.bgp.nu/download/0${majorVersion}.0${minorVersion}/suite3270-${finalAttrs.version}-src.tgz";
    hash = "sha256-AVdvpYWYzN09Nm/r+u9h49Hek+tgqT+axrpfr4QUTG8=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace Common/mkversion.py --replace-fail "int(os.environ['SOURCE_DATE_EPOCH'])" "1"
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
    libx11
    libxt
    libxaw
    libxmu
    bdftopcf
    mkfontdir
    font-adobe-100dpi
    font-adobe-utopia-100dpi
    font-bh-100dpi
    font-bh-lucidatypewriter-100dpi
    font-bitstream-100dpi
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
