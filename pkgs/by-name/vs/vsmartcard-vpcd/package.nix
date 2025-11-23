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
  version = "0.10";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    tag = "virtualsmartcard-${finalAttrs.version}";
    hash = "sha256-+BrX2aqByUvIUbN4K+sdq9bH29FD2rtTt4q+URPgx7A=";
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
