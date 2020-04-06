{ stdenv, fetchurl, qt4, qmake4Hook, AGL }:

stdenv.mkDerivation rec {
  name = "qwt-6.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/qwt/${name}.tar.bz2";
    sha256 = "1navkcnmn0qz8kzsyqmk32d929zl72l0b580w1ica7z5559j2a8m";
  };

  buildInputs = [
    qt4
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ AGL ];

  nativeBuildInputs = [ qmake4Hook ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  # qwt.framework output includes a relative reference to itself, which breaks dependents
  preFixup =
    stdenv.lib.optionalString stdenv.isDarwin ''
      echo "Attempting to repair qwt"
      install_name_tool -id "$out/lib/qwt.framework/Versions/6/qwt" "$out/lib/qwt.framework/Versions/6/qwt"
    '';

  qmakeFlags = [ "-after doc.path=$out/share/doc/${name}" ];

  meta = with stdenv.lib; {
    description = "Qt widgets for technical applications";
    homepage = http://qwt.sourceforge.net/;
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = stdenv.lib.licenses.qwt;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
    branch = "6";
  };
}
