{ stdenv, fetchFromGitHub, autoreconfHook, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "0qjd4bn2abwzic34cm0sw3srx02spszbsvfdbzbpn2cb62b5gjmw";
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
