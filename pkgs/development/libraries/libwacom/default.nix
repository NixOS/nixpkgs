{ stdenv, fetchFromGitHub, meson, ninja, glib, pkgconfig, udev, libgudev, doxygen }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.4.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "0m96zjj832l18rzg9l31ambm6rv9vnh2a1sfk8531da8m347z287";
  };

  nativeBuildInputs = [ pkgconfig meson ninja doxygen ];

  mesonFlags = [ "-Dtests=disabled" ];

  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = teams.freedesktop.members;
    license = licenses.mit;
  };
}
