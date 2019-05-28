{ stdenv, fetchFromGitHub, cmake, qtbase, qtsvg, qtx11extras, kwindowsystem }:

stdenv.mkDerivation rec {
  pname = "kvantum";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = pname;
    rev = "V${version}";
    sha256 = "14qi8hknx0vyw04rdl4sw5zscjf3cxv80mff32bpvhjc2d1n3ivq";
  };

  sourceRoot = "source/Kvantum";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase qtsvg qtx11extras kwindowsystem ];

  postPatch = ''
    sed -i -e "s,set(KVANTUM_STYLE_DIR .*/styles/\"),set(KVANTUM_STYLE_DIR \"$qtPluginPrefix/styles/\")," \
      style/CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "SVG-based theme engine for Qt, KDE and LXQt, with an emphasis on elegance, usability and practicality";
    homepage = https://github.com/tsujan/Kvantum;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
