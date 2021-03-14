{ lib, stdenv, fetchFromGitHub, meson, ninja, glib, pkg-config, udev, libgudev, doxygen }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.8";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "sha256-vkBkOE4aVX/6xKjslkqlZkh5jdYVEawvvBLpj8PpuiA=";
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
