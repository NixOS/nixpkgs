{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  makeWrapper,
  ffmpeg,
  wireplumber,
}:

buildNimPackage (finalAttrs: {
  pname = "terminal-oscilloscope";
  version = "0.1.0-unstable-2026-04-05";

  src = fetchFromGitHub {
    owner = "rolandnsharp";
    repo = "terminal-oscilloscope";
    rev = "cdd35235508658e0831b5443af8fbd79775583aa";
    hash = "sha256-4SmLfWmze8Zd2+8Qd38l/h5NDYXGRZky9YjulfQopgI=";
  };

  lockFile = ./lock.json;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/osc \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ ffmpeg ]}" \
      --prefix PATH : "${lib.makeBinPath [ wireplumber ]}"
  '';

  meta = {
    description = "Terminal oscilloscope with CRT phosphor physics";
    homepage = "https://github.com/rolandnsharp/terminal-oscilloscope";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "osc";
  };
})
