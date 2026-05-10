{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xautocfg";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "SFTtech";
    repo = "xautocfg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NxfuBknNRicmEAPBeMaNb57gpM0y0t+JmNMKpSNzlQM=";
  };

  buildInputs = [
    libx11
    libxi
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "out"}"
  ];

  meta = {
    homepage = "https://github.com/SFTtech/xautocfg";
    description = "Automatic keyboard repeat rate configuration for new keyboards";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jceb ];
    mainProgram = "xautocfg";
    platforms = lib.platforms.linux;
  };
})
