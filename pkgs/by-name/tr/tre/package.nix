{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  automake,
  darwin,
  gettext,
  libiconv,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tre";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "laurikari";
    repo = "tre";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5O8yqzv+SR8x0X7GtC2Pjo94gp0799M2Va8wJ4EKyf8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    automake
    libtool
  ];

  buildInputs =
    [
      gettext
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  autoreconfPhase = ''
    runHook preAutoreconf
    ./utils/autogen.sh
    runHook postAutoreconf
  '';

  meta = {
    description = "Lightweight and robust POSIX compliant regexp matching library";
    homepage = "https://laurikari.net/tre/";
    changelog = "https://github.com/laurikari/tre/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    mainProgram = "agrep";
    platforms = lib.platforms.unix;
  };
})
