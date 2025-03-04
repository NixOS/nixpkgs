{
  stdenv,
  fetchFromGitHub,
  lib,
  xdg-desktop-portal,
  ninja,
  meson,
  pkg-config,
  inih,
  systemd,
  scdoc,
}:
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hunkyburrito";
    repo = "xdg-desktop-portal-termfilechooser";
    rev = "c35af27e323a492cbb3b19bdd135657ae523caef";
    hash = "sha256-9bxhKkk5YFBhR2ylcDzlvt4ltYuF174w00EJK5r3aY0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    xdg-desktop-portal
    inih
    systemd
  ];

  mesonFlags = [ "-Dsd-bus-provider=libsystemd" ];

  meta = with lib; {
    description = "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage = "https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ body20002 ];
    mainProgram = "xdg-desktop-portal-termfilechooser";
  };
}
