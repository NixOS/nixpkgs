{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  boost,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  gmp,
  withGui,
  qtbase ? null,
  qttools ? null,
  wrapQtAppsHook ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vertcoin";
  version = "23.2";

  name = finalAttrs.pname + toString (lib.optional (!withGui) "d") + "-" + finalAttrs.version;

  src = fetchFromGitHub {
    owner = finalAttrs.pname + "-project";
    repo = finalAttrs.pname + "-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IhTNVKsvTAfnB1OT68uPMnbqSrZJfHPKWg3tnFsOGfk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ]
  ++ lib.optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
    gmp
  ]
  ++ lib.optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  meta = {
    description = "Digital currency with mining decentralisation and ASIC resistance as a key focus";
    homepage = "https://vertcoin.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
})
