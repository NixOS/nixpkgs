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
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "tau-OS";
    repo = "tau-hydrogen";
    rev = finalAttrs.version;
    hash = "sha256-ECrRWWS/Am0lfCIJw/BVZg53oLw79Im8d8KgAYxE+pw=";
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
