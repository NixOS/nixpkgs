{ stdenv, fetchFromGitHub, pkgconfig, qmake, qtx11extras, dtkcore }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkwm";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0vkx6vlz83pgawhdwqkwpq3dy8whxmjdzfpgrvm2m6jmspfk9bab";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    dtkcore
    qtx11extras
  ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags \
      QT_HOST_DATA=$out \
      INCLUDE_INSTALL_DIR=$out/include \
      LIB_INSTALL_DIR=$out/lib"
  '';

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = https://github.com/linuxdeepin/dtkwm;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
