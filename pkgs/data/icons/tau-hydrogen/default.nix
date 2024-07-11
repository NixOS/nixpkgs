{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  librsvg,
  xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tau-hydrogen";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "tau-OS";
    repo = "tau-hydrogen";
    rev = finalAttrs.version;
    hash = "sha256-8awcowBm0hwoYYm/wtKeqCWRhgXh2rI3UvAlL1tbj6c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    librsvg
    xorg.xcursorgen
  ];

  meta = with lib; {
    description = "GTK icon theme for tauOS";
    homepage = "https://github.com/tau-OS/tau-hydrogen";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
