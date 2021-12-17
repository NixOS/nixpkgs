{ lib, stdenv, fetchFromGitHub, qmake4Hook , qt4, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum-qt4";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "sha256-sY2slI9ZVuEurBIEaJMxUiKiUNXx+h7UEwEZKKr7R2Y=";
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

  meta = with lib; {
    description = "SVG-based Qt4 theme engine";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
