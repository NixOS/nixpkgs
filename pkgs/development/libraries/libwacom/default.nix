{ stdenv, fetchFromGitHub, meson, ninja, glib, pkg-config, udev, libgudev, doxygen }:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.6";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "10wphlk5v591mlvcyr6bjqp60zmhbpqg3lmsq9dza738v97ws8ci";
  };

  nativeBuildInputs = [ pkg-config meson ninja doxygen ];

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
