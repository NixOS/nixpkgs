{ stdenv, fetchFromGitHub, pkgconfig, qmake, qtx11extras, dtkcore,
  deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkwm";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "10l89i84vsh5knq9wg2php7vfg5rj5c9hrrl9rjlcidn1rz8yx6f";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = https://github.com/linuxdeepin/dtkwm;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
