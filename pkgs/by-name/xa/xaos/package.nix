{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  copyDesktopItems,
}:

let
  datapath = "$out/share/XaoS";
in
stdenv.mkDerivation rec {
  pname = "xaos";
  version = "4.3.4";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "xaos-project";
    repo = "XaoS";
    tag = "release-${version}";
    hash = "sha256-vOFwZbdbcrcJLHUa1QzxzadPcx5GF5uNPg+MZ7NbAPc=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.qttools
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [ qt6.qtbase ];

  QMAKE_LRELEASE = "lrelease";

  DEFINES = [
    "USE_OPENGL"
    "USE_FLOAT128"
  ];

  postPatch = ''
    substituteInPlace src/include/config.h \
      --replace-fail "/usr/share/XaoS" "${datapath}"
  '';

  desktopItems = [ "xdg/xaos.desktop" ];

  installPhase = ''
    runHook preInstall

    install -D bin/xaos "$out/bin/xaos"

    mkdir -p "${datapath}"
    cp -r tutorial examples catalogs "${datapath}"

    install -D "xdg/xaos.png" "$out/share/icons/xaos.png"

    install -D doc/xaos.6 "$man/man6/xaos.6"

    runHook postInstall
  '';

  meta = src.meta // {
    description = "Real-time interactive fractal zoomer";
    mainProgram = "xaos";
    homepage = "https://xaos-project.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
