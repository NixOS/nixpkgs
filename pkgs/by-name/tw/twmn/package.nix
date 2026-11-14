{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "twmn";
  version = "2025_10_23";

  src = fetchFromGitHub {
    owner = "sboli";
    repo = "twmn";
    tag = version;
    hash = "sha256-/yQtwoolGhtn19I+vus27OjaZgXXfhnWKQi+rUMozCY=";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    boost
  ];

  postPatch = ''
    sed -i s/-Werror// twmnd/twmnd.pro
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/* "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Notification system for tiling window managers";
    homepage = "https://github.com/sboli/twmn";
    platforms = with lib.platforms; linux;
    maintainers = [ lib.maintainers.matejc ];
    license = lib.licenses.lgpl3;
  };
}
