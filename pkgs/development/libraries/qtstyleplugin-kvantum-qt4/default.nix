{ stdenv, fetchFromGitHub, qmake4Hook , qt4, libX11, libXext }:

stdenv.mkDerivation rec {
  name = "qtstyleplugin-kvantum-qt4-${version}";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "0527bb03f2252269fd382e11181a34ca72c96b4b";
    sha256 = "0ky44s1fgqxraywagx1mv07yz76ppgiz3prq447db78wkwqg2d8p";
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
    homepage = https://github.com/tsujan/Kvantum;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
