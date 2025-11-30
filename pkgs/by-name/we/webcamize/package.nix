{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  ffmpeg,
  libgphoto2,
  kmod,
}:

stdenv.mkDerivation rec {
  pname = "webcamize";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "cowtoolz";
    repo = "webcamize";
    rev = "v${version}";
    hash = "sha256-rmATEcAcngCHidMFXNocrhP06LKNLEb+9jfFMGL4AKU=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    ffmpeg
    libgphoto2
    kmod
  ];

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Use (almost) any camera as a webcam on Linux";
    longDescription = ''
      Webcamize allows you to use basically any modern camera as a webcam on Linux—your DSLR,
      mirrorless, camcorder, point-and-shoot, and even some smartphones/tablets. It also gets
      many webcams that don't work out of the box on Linux up and running.
    '';
    homepage = "https://github.com/cowtoolz/webcamize";
    changelog = "https://github.com/cowtoolz/webcamize/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ManUtopiK ];
    mainProgram = "webcamize";
  };
}
