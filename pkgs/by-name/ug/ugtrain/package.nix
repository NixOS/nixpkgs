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
    sha256 = "0pw9lm8y83mda7x39874ax2147818h1wcibi83pd2x4rp1hjbkkn";
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
