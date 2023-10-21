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
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "tau-OS";
    repo = "tau-hydrogen";
    rev = finalAttrs.version;
    hash = "sha256-rfgSNytPCVCkAJ9N3kRw9mfcXr+JEqy1jyyDgXqxtsM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    librsvg
    xorg.xcursorgen
  ];

  meta = with lib; {
    description = "The GTK icon theme for tauOS";
    homepage = "https://github.com/tau-OS/tau-hydrogen";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ashvith-shetty ];
  };
})
