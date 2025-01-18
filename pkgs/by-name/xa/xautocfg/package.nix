{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXi,
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
    libX11
    libXi
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://github.com/SFTtech/xautocfg";
    description = "Automatic keyboard repeat rate configuration for new keyboards";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jceb ];
    mainProgram = "xautocfg";
    platforms = platforms.linux;
  };
})
