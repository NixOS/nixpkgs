{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXfixes,
  libXrandr,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpointerbarrier";
  version = "23.08";

  src = fetchurl {
    url = "https://www.uninformativ.de/git/xpointerbarrier/archives/xpointerbarrier-v${finalAttrs.version}.tar.gz";
    hash = "sha256-d0PcZ4z8JgN4ncPUGeJZwIV5vB7M0Jo7o1/L6mrJtUc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXfixes
    libXrandr
  ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = gitUpdater {
    url = "https://www.uninformativ.de/git/xpointerbarrier.git/";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://www.uninformativ.de/git/xpointerbarrier/file/README.html";
    description = "Create X11 pointer barriers around your working area";
    license = licenses.mit;
    maintainers = with maintainers; [
      AndersonTorres
      xzfc
    ];
    platforms = platforms.linux;
    mainProgram = "xpointerbarrier";
  };
})
