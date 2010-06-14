{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdeaccessibility-4.4.4.tar.bz2;
    sha256 = "0v3fbm7wp42fnyxzpk1vlp95z4jn9rf56i075p8g2xvz6gxxgh30";
  };
  # Missing: speechd, I was too lazy to implement this
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
