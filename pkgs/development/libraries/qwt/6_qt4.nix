{ lib, stdenv, fetchurl, qt4, qmake4Hook, AGL }:

stdenv.mkDerivation rec {
  pname = "qwt";
  version = "6.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/qwt/qwt-${version}.tar.bz2";
    sha256 = "0hf0mpca248xlqn7xnzkfj8drf19gdyg5syzklvq8pibxiixwxj0";
  };

  buildInputs = [
    qt4
  ] ++ lib.optionals stdenv.isDarwin [ AGL ];

  nativeBuildInputs = [ qmake4Hook ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  # qwt.framework output includes a relative reference to itself, which breaks dependents
  preFixup =
    lib.optionalString stdenv.isDarwin ''
      echo "Attempting to repair qwt"
      install_name_tool -id "$out/lib/qwt.framework/Versions/6/qwt" "$out/lib/qwt.framework/Versions/6/qwt"
    '';

  qmakeFlags = [ "-after doc.path=$out/share/doc/qwt-${version}" ];

  meta = with lib; {
    description = "Qt widgets for technical applications";
    homepage = "http://qwt.sourceforge.net/";
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = lib.licenses.qwt;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
    branch = "6";
  };
}
