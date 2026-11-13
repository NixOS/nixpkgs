{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/SFTtech/xautocfg/commit/7ffc353ebee60471cf6f6a377e7d689006acfd40.patch";
      hash = "sha256-ChY80PnV4fukXlK9yDn/7Ofy3LRwbCw557dN+86n/no=";
    })
  ];

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
