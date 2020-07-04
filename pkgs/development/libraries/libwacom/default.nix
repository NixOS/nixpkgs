{ stdenv, fetchFromGitHub, meson, ninja, glib, pkgconfig, udev, libgudev, doxygen }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "12g8jb67wj6sgg9ar2w8kkw1m1431rn9nd0j64qkrd3vy9g4l0hk";
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
