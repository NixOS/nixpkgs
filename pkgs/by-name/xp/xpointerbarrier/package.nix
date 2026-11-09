{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxfixes,
  libxrandr,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpointerbarrier";
  version = "25.08";

  src = fetchurl {
    url = "https://www.uninformativ.de/git/xpointerbarrier/archives/xpointerbarrier-v${finalAttrs.version}.tar.gz";
    hash = "sha256-63IYvTBrxT6WJwL5Ai9vFFro2j8IvUXvMy3IArYqbDw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxfixes
    libxrandr
  ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = gitUpdater {
    url = "https://www.uninformativ.de/git/xpointerbarrier.git/";
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://www.uninformativ.de/git/xpointerbarrier/file/README.html";
    description = "Create X11 pointer barriers around your working area";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xzfc
    ];
    platforms = lib.platforms.linux;
    mainProgram = "xpointerbarrier";
  };
})
