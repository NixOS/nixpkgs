{ stdenv, fetchurl, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  name = "qwt-5.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/qwt/${name}.tar.bz2";
    sha256 = "1dqa096mm6n3bidfq2b67nmdsvsw4ndzzd1qhl6hn8skcwqazzip";
  };

  propagatedBuildInputs = [ qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

  postPatch = ''
    sed -e "s@\$\$\[QT_INSTALL_PLUGINS\]@$out/lib/qt4/plugins@" -i designer/designer.pro
    sed -e "s|INSTALLBASE.*=.*|INSTALLBASE = $out|g" -i qwtconfig.pri
  '';

  preConfigure = ''
    qmakeFlags="$qmakeFlags INSTALLBASE=$out -after doc.path=$out/share/doc/${name}"
  '';

  meta = with stdenv.lib; {
    description = "Qt widgets for technical applications";
    homepage = http://qwt.sourceforge.net/;
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = stdenv.lib.licenses.qwt;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
