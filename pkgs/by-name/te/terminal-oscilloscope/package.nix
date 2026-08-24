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
  version = "0.1.0-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "rolandnsharp";
    repo = "terminal-oscilloscope";
    rev = "f2a94befaa4b9de1c01a410f132e08032b447844";
    hash = "sha256-L1/1Hg7ig286KbNuo9ED5mJxpUIVBFdH5KHnVdBm390=";
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
