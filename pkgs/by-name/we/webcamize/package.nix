{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
  libgphoto2,
  kmod,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "webcamize";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "cowtoolz";
    repo = "webcamize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rmATEcAcngCHidMFXNocrhP06LKNLEb+9jfFMGL4AKU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ffmpeg
    libgphoto2
    kmod
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 -t $out/bin bin/webcamize
  '';

  meta = {
    description = "Use (almost) any camera as a webcam";
    homepage = "https://github.com/cowtoolz/webcamize";
    changelog = "https://github.com/cowtoolz/webcamize/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ imurx ];
    mainProgram = "webcamize";
  };
})
