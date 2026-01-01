{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ninja,
  meson,
  scdoc,
  wayland-protocols,
  wayland-scanner,
  freetype,
  harfbuzz,
  cairo,
  pango,
  wayland,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "tofi";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "philj56";
    repo = "tofi";
    rev = "v${version}";
    sha256 = "sha256-lokp6Zmdt7WuAyuRnHBkKD4ydbNiQY7pEVY97Z62U90=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-protocols
    wayland-scanner
  ];
  buildInputs = [
    freetype
    harfbuzz
    cairo
    pango
    wayland
    libxkbcommon
  ];

<<<<<<< HEAD
  meta = {
    description = "Tiny dynamic menu for Wayland";
    homepage = "https://github.com/philj56/tofi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbergroth ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Tiny dynamic menu for Wayland";
    homepage = "https://github.com/philj56/tofi";
    license = licenses.mit;
    maintainers = with maintainers; [ fbergroth ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "tofi";
  };
}
