{ stdenv, fetchFromGitHub, autoreconfHook, glib, pkgconfig, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libwacom-${version}";
  version = "0.33";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "0np0a7rpnlm9iqw1i8ycz5mprin6bb99p4h522v9vjk4lhzsp34m";
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
