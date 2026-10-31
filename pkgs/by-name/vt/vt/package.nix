{
  lib,
  stdenv,
  autoconf,
  bzip2,
  curl,
  fetchFromGitHub,
  xz,
  zlib,
}:
let

  src = fetchFromGitHub {
    owner = "atks";
    repo = "vt";
    rev = "c6bd1591a23a1d116d52834a627c00bbf7ed4a64";
    hash = "sha256-Y9Tq/kB8GpWAeCQyFm86bFTs5pEZtBp7LLjzmTMUPoU=";
    fetchSubmodules = true;
  };
  version = "unstable-${lib.substring 0 7 src.rev}";
in

stdenv.mkDerivation {
  pname = "vt";

  inherit src version;

  dontConfigure = true;

  postPatch = ''
    echo '#define HTSCODECS_VERSION_TEXT "${version}"' > lib/htslib/htscodecs/htscodecs/version.h
  '';

  strictDeps = true;

  nativeBuildInputs = [ autoconf ];

  buildInputs = [
    zlib
    bzip2
    xz
    curl
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 vt $out/bin/vt
    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Tool set for short variant discovery in genetic sequence data";
    homepage = "https://github.com/atks/vt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rollf ];
    mainProgram = "vt";
    platforms = lib.platforms.linux;
  };
}
