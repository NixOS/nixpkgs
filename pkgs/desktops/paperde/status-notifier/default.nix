{ stdenv, lib, ninja, meson, fetchFromGitLab, pkgconfig, cmake, wrapQtAppsHook, qtbase }:
stdenv.mkDerivation rec {
  pname = "status-notifier";
  version = "v0.1.1";
  src = fetchFromGitLab {
    hash = "sha256-xNq7elaj+deDPKlm8BSDdP0PpCtn9WC919AK7Hvh10g=";
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
    wrapQtAppsHook
    qtbase
  ];
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release" ];

  meta = with lib; {
    description = "Implementation of the XDG Status Notification Specifications. DFL::StatusNotifierWatcher and DFL::StatusNotifierItem classes make it easy to create a system tray applications";
    homepage = "https://gitlab.com/desktop-frameworks/status-notifier";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
