{ stdenv, mkDerivation, fetchFromGitHub, qmake, qtbase, deepin }:

mkDerivation rec {
  pname = "udisks2-qt5";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0mqxm6ixzpbg0rr6ly2kvnkpag8gjza67ya7jv4i4rihbq1d0wzi";
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

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "UDisks2 D-Bus interfaces binding for Qt5";
    homepage = https://github.com/linuxdeepin/udisks2-qt5;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
