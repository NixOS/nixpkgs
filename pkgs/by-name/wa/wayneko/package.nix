{
  lib,
  stdenv,
  fetchFromSourcehut,
  pixman,
  pkg-config,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "wayneko";
  version = "0-unstable-2024-03-29";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wayneko";
    rev = "c1919dc3a7e610d30e4c06efaa5af85941f27d86";
    hash = "sha256-2cbEcDK6WZPe4HvY1pxmZVyDAj617VP1l0Gn7uSlNaE=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail -Werror ""
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    pixman
    wayland
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Neko on Wayland";
    homepage = "https://sr.ht/~leon_plickat/wayneko";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "wayneko";
    platforms = lib.platforms.linux;
  };
}
