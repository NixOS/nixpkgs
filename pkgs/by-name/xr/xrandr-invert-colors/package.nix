{
  lib,
  stdenv,
  fetchFromGitHub,
  libXrandr,
  xorg,
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
    xorg.libxcb
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv xrandr-invert-colors.bin xrandr-invert-colors
    install -Dm755 xrandr-invert-colors $out/bin
    runHook postInstall
  '';

  meta = {
    description = "inverts colors on all screens, using Xrand";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/zoltanp/xrandr-invert-colors";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "xrandr-invert-colors";
  };
})
