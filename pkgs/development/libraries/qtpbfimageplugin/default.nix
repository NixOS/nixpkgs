{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "qtpbfimageplugin";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "QtPBFImagePlugin";
    tag = version;
    hash = "sha256-3Tfh92ozitvL9EiGJy8Q20C8zDx5eNNJFa7KDXDuS6Y=";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
  ];

  dontWrapQtApps = true;

  postPatch = ''
    # Fix plugin dir
    substituteInPlace pbfplugin.pro \
      --replace-warn "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = {
    description = "Qt image plugin for displaying Mapbox vector tiles";
    longDescription = ''
      QtPBFImagePlugin is a Qt image plugin that enables applications capable of
      displaying raster MBTiles maps or raster XYZ online maps to also display PBF
      vector tiles without (almost) any application modifications.
    '';
    homepage = "https://github.com/tumic0/QtPBFImagePlugin";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
