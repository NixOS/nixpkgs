{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  librsvg,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tau-hydrogen";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "tau-OS";
    repo = "tau-hydrogen";
    rev = finalAttrs.version;
    hash = "sha256-nnQ0lkHtkOjJhF4NSMqjt0deddYjMnHHlANlHoZS2wY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    librsvg
    xorg.xcursorgen
  ];

<<<<<<< HEAD
  meta = {
    description = "GTK icon theme for tauOS";
    homepage = "https://github.com/tau-OS/tau-hydrogen";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "GTK icon theme for tauOS";
    homepage = "https://github.com/tau-OS/tau-hydrogen";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
})
