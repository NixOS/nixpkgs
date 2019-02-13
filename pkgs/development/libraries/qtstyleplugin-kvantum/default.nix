{ stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, libX11, libXext, qttools }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "0w4iqpkagrwvhahdl280ni06b7x1i621n3z740g84ysp2n3dv09l";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras libX11 libXext  ];

  sourceRoot = "source/Kvantum";

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/style.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = with stdenv.lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
