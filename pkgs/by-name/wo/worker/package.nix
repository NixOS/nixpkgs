{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "worker";
  version = "5.2.2";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/worker-${finalAttrs.version}.tar.gz";
    hash = "sha256-xJxdOb6eEr8suf3u/vouYCGzTFugJpLtoKyCMeuoJv4=";
  };

  buildInputs = [ libX11 ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  meta = {
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    description = "Advanced orthodox file manager";
    longDescription = ''
      Worker is a two-pane file manager for the X Window System on UN*X. The
      directories and files are shown in two independent panels supporting a lot
      of advanced file manipulation features. The main focus is to make managing
      files easy with full keyboard control, also assisting in finding files and
      directories by using history of accessed directories, live filtering, and
      access to commands by using the keyboard.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "worker";
    maintainers = with lib.maintainers; [ ];
    inherit (libX11.meta) platforms;
  };
})
