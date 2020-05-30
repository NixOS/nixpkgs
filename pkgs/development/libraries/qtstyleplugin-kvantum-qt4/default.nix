{ stdenv, fetchFromGitHub, qmake4Hook , qt4, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum-qt4";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "0cv0lxyi2sr0k7f03rsh1j28avdxd0l0480jsa95ca3d2lq392g3";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 libX11 libXext ];

  postUnpack = "sourceRoot=\${sourceRoot}/Kvantum";

  buildPhase = ''
    qmake kvantum.pro
    make
  '';

  installPhase = ''
    mkdir $TMP/kvantum
    make INSTALL_ROOT="$TMP/kvantum" install
    mv $TMP/kvantum/usr/ $out
    mv $TMP/kvantum/${qt4}/lib $out
  '';

  meta = with stdenv.lib; {
    description = "SVG-based Qt4 theme engine";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
