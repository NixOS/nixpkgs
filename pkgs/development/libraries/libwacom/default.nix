{ stdenv, fetchFromGitHub, autoreconfHook, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.32";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "15fz2z2h2awh2l08cv663s1zk4z8bmvvivwnnfvx2q8lkqgfkr7f";
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
