{ stdenv, lib, ninja, meson, fetchFromGitLab, pkgconfig, cmake, wrapQtAppsHook, qtbase }:
stdenv.mkDerivation rec {
  pname = "ipc";
  version = "v0.1.1";
  src = fetchFromGitLab {
    hash = "sha256-7tjO7s14YdvgiApgJr5SpmLVA3jz644nuVRNiJQi9k4=";
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
    description = "A very simple set of IPC classes for inter-process communication";
    homepage = "https://gitlab.com/desktop-frameworks/ipc";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
