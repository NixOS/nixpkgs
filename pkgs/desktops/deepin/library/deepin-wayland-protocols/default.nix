{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
}:

stdenv.mkDerivation rec {
  pname = "deepin-wayland-protocols";
  version = "1.6.0-deepin.1.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-8Im3CueC8sYA5mwRU/Z7z8HA4mPQvVSqcTD813QCYxo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "XML files of the non-standard wayland protocols use in deepin";
    homepage = "https://github.com/linuxdeepin/deepin-wayland-protocols";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
