{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  protobuf,
}:

stdenv.mkDerivation rec {
  pname = "qtpbfimageplugin";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "QtPBFImagePlugin";
    rev = version;
    sha256 = "sha256-7DaJvpApdnh5+9vd0spUDorwzpzLEaJ8477qE8nJLOc=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    qtbase
    protobuf
  ];

  dontWrapQtApps = true;

  postPatch =
    ''
      # Fix plugin dir
      substituteInPlace pbfplugin.pro \
        --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
    ''
    + lib.optionalString stdenv.isDarwin ''
      # Fix darwin build
      substituteInPlace pbfplugin.pro \
        --replace '$$PROTOBUF/include' '${protobuf}/include' \
        --replace '$$PROTOBUF/lib/libprotobuf-lite.a' '${protobuf}/lib/libprotobuf-lite.dylib'
    '';

  meta = with lib; {
    description = "Qt image plugin for displaying Mapbox vector tiles";
    longDescription = ''
      QtPBFImagePlugin is a Qt image plugin that enables applications capable of
      displaying raster MBTiles maps or raster XYZ online maps to also display PBF
      vector tiles without (almost) any application modifications.
    '';
    homepage = "https://github.com/tumic0/QtPBFImagePlugin";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
