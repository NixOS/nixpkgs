{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, glib
, pkg-config
, udev
, libgudev
, python3
}:

stdenv.mkDerivation rec {
  pname = "libwacom";
  version = "1.99.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${version}";
    sha256 = "sha256-WGW/4m+BTe6dEigUcuUIZjoTeamInW6zrtrlaqKM6Js=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  buildInputs = [
    glib
    udev
    libgudev
  ];

  mesonFlags = [
    "-Dtests=disabled"
  ];

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = teams.freedesktop.members;
    license = licenses.mit;
  };
}
