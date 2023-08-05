{ lib, stdenv, fetchFromGitHub, qmake4Hook , qt4, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum-qt4";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    hash = "sha256-48Blio8qHLmXSKG0c1tphXSfiwQXs0Xqwxe187nM3Ro=";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 libX11 libXext ];

  sourceRoot = "${src.name}/Kvantum";

  buildPhase = ''
    runHook preBuild
    qmake kvantum.pro
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $TMP/kvantum
    make INSTALL_ROOT="$TMP/kvantum" install
    mv $TMP/kvantum/usr/ $out
    mv $TMP/kvantum/${qt4}/lib $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "SVG-based Qt4 theme engine";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
