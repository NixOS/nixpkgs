{ stdenv, lib, ninja, qtx11extras, meson, ipc, fetchFromGitLab, pkgconfig, cmake, glib, wrapQtAppsHook, qtbase }:
# autoreconfHook
stdenv.mkDerivation rec {
  pname = "applications";
  version = "v0.1.1";
  src = fetchFromGitLab {
    hash = "sha256-P5KOqsOKnGXhGiU4solykGym69m8s5yFY5WBRE3ZIFw=";
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
    ipc
    glib
    qtbase
    qtx11extras
  ];
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release" ];

  meta = with lib; {
    description = "This library provides a thin wrapper around QApplication, QGuiApplication and QCoreApplication, to provide
single-instance functionality";
    homepage = "https://gitlab.com/desktop-frameworks/applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
