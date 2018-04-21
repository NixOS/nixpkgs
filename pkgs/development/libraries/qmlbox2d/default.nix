{stdenv, qtdeclarative, fetchFromGitHub, qmake }:
stdenv.mkDerivation rec {
  name = "qml-box2d-2018-03-16";
  src = fetchFromGitHub {
    owner = "qml-box2d";
    repo = "qml-box2d";
    sha256 = "1fbsvv28b4r0szcv8bk5gxpf8v534jp2axyfp438384sy757wsq2";
    rev = "21e57f1";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtdeclarative ];

  patchPhase = ''
    substituteInPlace box2d.pro \
      --replace '$$[QT_INSTALL_QML]' "/$qtQmlPrefix/"
    qmakeFlags="$qmakeFlags PREFIXSHORTCUT=$out"
    '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with stdenv.lib; {
    description = "A QML plugin for Box2D engine";
    homepage = "https://github.com/qml-box2d/qml-box2d";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
