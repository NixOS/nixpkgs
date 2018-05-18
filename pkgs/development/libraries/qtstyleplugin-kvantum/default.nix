{ stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, libX11, libXext, qttools }:

stdenv.mkDerivation rec {
  name = "qtstyleplugin-kvantum-${version}";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "a6daa1a6df3c5d4abc7ea39ef7028ddea2addbf6";
    sha256 = "1zns4x95h0ydiwx8yw0bmyg4lc2sy7annmdrg66sx753x3177zxp";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras libX11 libXext  ];

  postUnpack = "sourceRoot=\${sourceRoot}/Kvantum";

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
