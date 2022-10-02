{ lib, stdenv, fetchurl, qtbase, qtsvg, qttools, qmake }:

stdenv.mkDerivation rec {
  pname = "qwt";
  version = "6.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/qwt/qwt-${version}.tar.bz2";
    sha256 = "sha256-mUYNMcEV7kEXsBddiF9HwsWQ14QgbwmBXcBY++Xt4fY=";
  };

  propagatedBuildInputs = [ qtbase qtsvg qttools ];
  nativeBuildInputs = [ qmake ];

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  qmakeFlags = [ "-after doc.path=$out/share/doc/qwt-${version}" ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt widgets for technical applications";
    homepage = "http://qwt.sourceforge.net/";
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = licenses.qwt;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
