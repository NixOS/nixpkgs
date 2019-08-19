{ stdenv, fetchFromGitHub, autoreconfHook, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.99.901";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "1v98x8fwyz4lx9yvzq05xzsici2k64wm2wcbhqiby23dcj2ix8ka";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ glib udev libgudev ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://linuxwacom.github.io/;
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    license = licenses.mit;
  };
}
