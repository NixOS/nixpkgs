{
  lib,
  stdenv,
  fetchFromGitHub,
  libXrandr,
}:

stdenv.mkDerivation rec {
  pname = "xrandr-invert-colors";
  version = "0.02";

  src = fetchFromGitHub {
    owner = "zoltanp";
    repo = "xrandr-invert-colors";
    rev = "v${version}";
    sha256 = "sha256-MIbHNJFDQsvjPUbperTKKbHY5GSgItvRyV5OsfpzYT4=";
  };

  buildInputs = [ libXrandr ];

  installPhase = ''
    mkdir -p $out/bin
    mv xrandr-invert-colors.bin xrandr-invert-colors
    install xrandr-invert-colors $out/bin
  '';

  meta = with lib; {
    description = "Inverts the colors of your screen";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/zoltanp/xrandr-invert-colors";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "xrandr-invert-colors";
  };
}
