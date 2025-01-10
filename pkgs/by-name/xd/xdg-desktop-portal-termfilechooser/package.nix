{ stdenv
, fetchgit
, lib
, xdg-desktop-portal
, ninja
, meson
, pkg-config
, inih
, systemd
, scdoc
, pipewire
, wayland
, wayland-protocols
, libgbm
, wayland-scanner
,
}:
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "0.4.0";

  src = fetchgit {
    url =
      "https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser.git";
    rev = "a0b20c06e3d45cf57218c03fce1111671a617312";
    hash = "sha256-MOS2dS2PeH5O0FKxZfcJUAmCViOngXHZCyjRmwAqzqE=";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];

  buildInputs = [
    xdg-desktop-portal
    inih
    systemd
    pipewire
    wayland
    wayland-protocols
    libgbm
  ];

  mesonFlags = [ "-Dsd-bus-provider=libsystemd" ];

  meta = with lib; {
    description =
      "xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage =
      "https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ body20002 ];
    mainProgram = "xdg-desktop-portal-termfilechooser";
  };
}
