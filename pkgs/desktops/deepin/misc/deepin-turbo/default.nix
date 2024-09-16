{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  dtkwidget,
}:

stdenv.mkDerivation rec {
  pname = "deepin-turbo";
  version = "0.0.6.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-t6/Ws/Q8DO0zBzrUr/liD61VkxbOv4W4x6VgMWr+Ozk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [ dtkwidget ];

  postPatch = ''
    substituteInPlace src/{booster-dtkwidget/CMakeLists.txt,booster-desktop/{CMakeLists.txt,desktop.conf},booster-generic/CMakeLists.txt} --replace "/usr" "$out"
  '';

  meta = with lib; {
    description = "Daemon that helps to launch dtk applications faster";
    homepage = "https://github.com/linuxdeepin/deepin-turbo";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
