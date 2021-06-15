{ lib, stdenv, fetchFromGitHub, meson, ninja, glib, pkg-config, udev, libgudev, doxygen }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.9";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "sha256-o1xCSrWKPzz1GePEVB1jgx2cGzRtw0I6c4wful08Vx4=";
  };

  nativeBuildInputs = [ pkg-config meson ninja doxygen ];

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
