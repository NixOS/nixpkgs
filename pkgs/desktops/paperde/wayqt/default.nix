{ stdenv, lib, ninja, qtx11extras, meson, fetchFromGitLab, wayland, wayland-protocols, pkgconfig, cmake, wrapQtAppsHook, qtbase }:
stdenv.mkDerivation rec {
  pname = "wayqt";
  version = "v0.1.1";
  src = fetchFromGitLab {
    hash = "sha256-PL8XMddOtHsxgT6maDXMDvbHp2oW8CsMeKVtIAlmq7w=";
    domain = "gitlab.com";
    owner = "desktop-frameworks";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];

  buildInputs = [
    ninja
    meson
    pkgconfig
    cmake
    wayland
    wayland-protocols
    qtbase
    wrapQtAppsHook
    qtx11extras
  ];
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release" ];

  meta = with lib; {
    description = "A Qt-based wrapper for various wayland protocols";
    homepage = "https://gitlab.com/desktop-frameworks/wayqt";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
