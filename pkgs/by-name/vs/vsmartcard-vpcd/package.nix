{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  autoreconfHook,
  pcsclite,
  qrencode,
  python3,
  help2man,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vsmartcard-vpcd";
  version = "0.9-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    rev = "7369dae26bcb709845003ae2128b8db9df7031ae";
    hash = "sha256-mfw/Yv12ceBVZIyAKJqBh+w4otj3rYYZbJUjKRLcsr4=";
  };

  sourceRoot = "${finalAttrs.src.name}/virtualsmartcard";

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    help2man
  ];

  buildInputs = [
    pcsclite
    qrencode
    (python3.withPackages (
      pp: with pp; [
        pyscard
        pycrypto
        pbkdf2
        pillow
        gnureadline
      ]
    ))
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "--enable-infoplist";

  meta = {
    description = "Emulates a smart card and makes it accessible through PC/SC";
    homepage = "http://frankmorgner.github.io/vsmartcard/virtualsmartcard/README.html";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ stargate01 ];
  };
})
