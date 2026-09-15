{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6Packages,
}:

stdenv.mkDerivation {
  pname = "traceshark";
  version = "unstable-2025-04-13";

  src = fetchFromGitHub {
    owner = "cunctator";
    repo = "traceshark";
    rev = "d4c52bbafe9e3ae3c856a1f7922a75a4af95d88c";
    sha256 = "sha256-qR4uBT2qURYuWrMVbVq2rBmuDrsRArvo/JW++NHS3l4=";
  };

  buildInputs = [ qt6Packages.qtbase ];
  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    qt6Packages.qmake
  ];
  qmakeFlags = [ "CUSTOM_INSTALL_PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A tool for Linux kernel ftrace and perf events visualization";
    homepage = "https://github.com/cunctator/traceshark";
    license = licenses.gpl3;
    mainProgram = "traceshark";
    maintainers = with maintainers; [ jjjollyjim ];
    platforms = platforms.linux;
  };
}
