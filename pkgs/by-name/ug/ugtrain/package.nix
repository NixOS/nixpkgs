{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  scanmem,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4.1";
  pname = "ugtrain";

  src = fetchFromGitHub {
    owner = "ugtrain";
    repo = "ugtrain";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ds4lYbiZdNHuQHFFxgNEAR0SRFfkoDT6Ua0O5FGliV8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    scanmem
  ];

  meta = {
    homepage = "https://github.com/ugtrain/ugtrain";
    description = "Universal Elite Game Trainer for CLI (Linux game trainer research project)";
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
})
