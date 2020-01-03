{ stdenv, fetchFromGitHub, meson, ninja, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "037vnyfg7nim6h3f4m04w6a9pr6hi04df14qpys580kf5xnf87nz";
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];

  mesonFlags = [ "-Dtests=false" ];

  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://linuxwacom.github.io/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    license = licenses.mit;
  };
}
