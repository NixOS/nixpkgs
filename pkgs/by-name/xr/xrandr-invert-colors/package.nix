{
  lib,
  stdenv,
  fetchFromGitHub,
  libXrandr,
  libxcb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrandr-invert-colors";
  version = "0.02";

  src = fetchFromGitHub {
    owner = "zoltanp";
    repo = "xrandr-invert-colors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MIbHNJFDQsvjPUbperTKKbHY5GSgItvRyV5OsfpzYT4=";
  };

  buildInputs = [
    libXrandr
    libxcb
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 xrandr-invert-colors.bin $out/bin/xrandr-invert-colors
    runHook postInstall
  '';

  meta = {
    description = "Invert colors on all screens, using XRandR";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/zoltanp/xrandr-invert-colors";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "xrandr-invert-colors";
  };
})
