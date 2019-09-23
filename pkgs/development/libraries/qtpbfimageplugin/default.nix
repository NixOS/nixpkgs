{ stdenv, fetchFromGitHub, qmake, qtbase, protobuf }:

stdenv.mkDerivation rec {
  pname = "qtpbfimageplugin";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "QtPBFImagePlugin";
    rev = version;
    sha256 = "0d39i7rmhrmm2df49gd47zm37gnz3fmyr6hfc6hhzvk08jb6956r";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase protobuf ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace pbfplugin.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"

    # Fix darwin build
    substituteInPlace pbfplugin.pro \
      --replace '$$PROTOBUF/lib/libprotobuf-lite.a' '${protobuf}/lib/libprotobuf-lite.dylib'
  '';

  meta = with stdenv.lib; {
    description = "Qt image plugin for displaying Mapbox vector tiles";
    longDescription = ''
      QtPBFImagePlugin is a Qt image plugin that enables applications capable of
      displaying raster MBTiles maps or raster XYZ online maps to also display PBF
      vector tiles without (almost) any application modifications.
    '';
    homepage = https://github.com/tumic0/QtPBFImagePlugin;
    license = licenses.lgpl3;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
}
