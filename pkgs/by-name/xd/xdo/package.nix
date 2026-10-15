{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  libxcb-util,
  libxcb-wm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdo";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "xdo";
    rev = finalAttrs.version;
    hash = "sha256-ycO0W2+nVb9pk58eROY7yXngNNNQ9DtX22pJyZ7PcsA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    libxcb
    libxcb-wm
    libxcb-util
  ];

  meta = {
    description = "Small X utility to perform elementary actions on windows";
    homepage = "https://github.com/baskerville/xdo";
    maintainers = with lib.maintainers; [ meisternu ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    mainProgram = "xdo";
  };
})
