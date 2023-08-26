{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  dart-sass,
  ninja
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tau-helium";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "tau-OS";
    repo = "tau-helium";
    rev = finalAttrs.version;
    hash = "sha256-IsNVA5lpcgggZU1bAFiJr9QsPuytkBUa3P3ixHOCkcE=";
  };

  nativeBuildInputs = [
    meson
    dart-sass
    ninja
  ];

  mesonFlags = [
    "-Dgtk4=true"
    "-Dshell=false"
  ];

  meta = with lib; {
    description = "The GTK/GNOME Shell theme for tauOS";
    homepage = "https://github.com/tau-OS/tau-helium";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ashvith-shetty ];
  };
})
