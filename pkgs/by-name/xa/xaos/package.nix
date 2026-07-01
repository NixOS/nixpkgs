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
stdenv.mkDerivation (finalAttrs: {
  pname = "xaos";
  version = "4.3.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "xaos-project";
    repo = "XaoS";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-dGfmX55bm2BCFl7mRit88ULAcJ0VP15yVGI7nhRH0Ig=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.qttools
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [ qt6.qtbase ];

  env = {
    QMAKE_LRELEASE = "lrelease";

    DEFINES = toString [
      "USE_OPENGL"
      "USE_FLOAT128"
    ];
  };

  postPatch = ''
    substituteInPlace src/include/config.h \
      --replace-fail "/usr/share/XaoS" "${datapath}"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace XaoS.pro \
      --replace-fail \
        "QMAKE_APPLE_DEVICE_ARCHS = x86_64 arm64" \
        "QMAKE_APPLE_DEVICE_ARCHS = ${if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64"}"
  '';

  desktopItems = [ "xdg/xaos.desktop" ];

  postInstall = ''
    mkdir -p "${datapath}"
    cp -r tutorial examples catalogs "${datapath}"
    install -D "xdg/xaos.png" "$out/share/icons/xaos.png"
  '';

  meta = finalAttrs.src.meta // {
    description = "Real-time interactive fractal zoomer";
    mainProgram = "xaos";
    homepage = "https://xaos-project.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
