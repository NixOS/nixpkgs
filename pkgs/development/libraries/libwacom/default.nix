{ lib, stdenv, fetchFromGitHub, meson, ninja, glib, pkg-config, udev, libgudev, doxygen, python3 }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.10";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "sha256-Q7b54AMAxdIzN7TUuhIdlrXaVtj2szV4n3y9bAE0LsU=";
  };

  nativeBuildInputs = [ pkg-config meson ninja doxygen python3 ];

  mesonFlags = [ "-Dtests=disabled" ];

  buildInputs = [ glib udev libgudev ];

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = teams.freedesktop.members;
    license = licenses.mit;
  };
}
