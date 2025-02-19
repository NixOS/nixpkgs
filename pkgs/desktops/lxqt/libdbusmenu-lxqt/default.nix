{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  wrapQtAppsHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libdbusmenu-lxqt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-OF12t08hOuDsl80n4lXO3AFCf29f01eDpoRcbXmI4+I=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Qt implementation of the DBusMenu protocol";
    homepage = "https://github.com/lxqt/libdbusmenu-lxqt";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
