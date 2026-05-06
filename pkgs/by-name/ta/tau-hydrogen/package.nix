{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  librsvg,
  xcursorgen,
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
    xcursorgen
  ];

  meta = {
    description = "GTK icon theme for tauOS";
    homepage = "https://github.com/tau-OS/tau-hydrogen";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
