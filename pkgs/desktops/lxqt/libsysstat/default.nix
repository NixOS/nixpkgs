{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  lxqt-build-tools,
  wrapQtAppsHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libsysstat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-CwQz0vaBhMe32xBoSgFkxSwx3tnIHutp9Vs32FvTNVU=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library used to query system info and statistics";
    homepage = "https://github.com/lxqt/libsysstat";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
