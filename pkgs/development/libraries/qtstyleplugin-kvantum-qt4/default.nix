{ lib, stdenv, fetchFromGitHub, qmake4Hook , qt4, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum-qt4";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    hash = "sha256-Faex1NF5bJa0GdC+Sz4p6kHaGUtAkqZlNGi0TSc5ckw=";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 libX11 libXext ];

  sourceRoot = "source/Kvantum";

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
