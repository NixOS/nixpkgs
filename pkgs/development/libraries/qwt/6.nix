{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "qwt-6.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/qwt/${name}.tar.bz2";
    sha256 = "00klw6jsn8z3dnhxg52pqg3hg5mw2sih8prwjxm1hzcivgqxkqx7";
  };

  propagatedBuildInputs = [ qt4 ];

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  configurePhase = "qmake -after doc.path=$out/share/doc/${name} -r";

  meta = with stdenv.lib; {
    description = "Qt widgets for technical applications";
    homepage = http://qwt.sourceforge.net/;
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = stdenv.lib.licenses.qwt;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    branch = "6";
  };
}
