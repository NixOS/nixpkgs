{ lib, stdenv, fetchFromGitHub, qmake, qtbase, protobuf }:

stdenv.mkDerivation rec {
  pname = "qtpbfimageplugin";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "QtPBFImagePlugin";
    rev = version;
    sha256 = "063agzcrcihasqqk2yqxqxg9xknjs99y6vx3n1v7md7dqnfv4iva";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase protobuf ];

  dontWrapQtApps = true;

  postPatch = ''
    # Fix plugin dir
    substituteInPlace pbfplugin.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '' + lib.optionalString stdenv.isDarwin ''
    # Fix darwin build
    substituteInPlace pbfplugin.pro \
      --replace '$$PROTOBUF/include' '${protobuf}/include' \
      --replace '$$PROTOBUF/lib/libprotobuf-lite.a' '${protobuf}/lib/libprotobuf-lite.dylib'
  '';

  # error: 'path' is unavailable: introduced in macOS 10.15
  qmakeFlags = lib.optionals stdenv.isDarwin [
    "CONFIG+=c++17"
    "QMAKE_MACOSX_DEPLOYMENT_TARGET=10.15"
  ];

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
