{ stdenv, lib, ninja, meson, fetchFromGitLab, pkgconfig, cmake, wrapQtAppsHook, qtbase }:
stdenv.mkDerivation rec {
  pname = "login1";
  version = "v0.1.1";
  src = fetchFromGitLab {
    hash = "sha256-iPujkSKXHXd60EG7L+s87/ejTotPbRHKXwrLdFDzzpU=";
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
    description = "Implementation of systemd/elogind for DFL";
    homepage = "https://gitlab.com/desktop-frameworks/login1";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
