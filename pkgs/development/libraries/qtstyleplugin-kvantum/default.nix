{ stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, kwindowsystem, libX11, libXext, qttools }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "0aqlv7mj7r9vjm6pvb8pv3cyx35lgz8rjjas3k8wfdr3sqyyy25g";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras kwindowsystem libX11 libXext  ];

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
