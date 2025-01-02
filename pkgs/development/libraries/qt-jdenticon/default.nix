{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt-jdenticon";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "qt-jdenticon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3XJHBn+S6oDPfmWSyFDW7qkg69wuxj+GUqMBUCDp3n0=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase ];

  dontWrapQtApps = true;

  postPatch = ''
    # Fix plugins dir
    substituteInPlace QtIdenticon.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = {
    description = "Qt plugin for generating highly recognizable identicons";
    homepage = "https://github.com/Nheko-Reborn/qt-jdenticon";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ unclechu ];
  };
})
