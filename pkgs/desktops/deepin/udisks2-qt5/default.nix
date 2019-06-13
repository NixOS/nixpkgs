{ stdenv, fetchFromGitHub, qmake, qtbase, pkgconfig, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "udisks2-qt5";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1gk4jmq7mrzk181r6man2rz1iyzkfasz7053a30h4nn24mq8ikig";
  };

  nativeBuildInputs = [
    deepin.setupHook
    qmake
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    searchHardCodedPaths
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "UDisks2 D-Bus interfaces binding for Qt5";
    homepage = https://github.com/linuxdeepin/udisks2-qt5;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
