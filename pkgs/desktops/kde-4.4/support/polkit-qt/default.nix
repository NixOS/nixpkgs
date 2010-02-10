{stdenv, fetchurl, cmake, qt4, policykit, automoc4, lib}:

stdenv.mkDerivation {
  name = "polkit-qt-0.9.3";
  src = fetchurl {
    url = mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-0.9.3.tar.bz2;
    sha256 = "08mz8p98nlxnxy1l751jg1010vgjq2f2d6n4cj27jvihqkpbaixn";
  };
  includeAllQtDirs = true;
  buildInputs = [ cmake qt4 policykit automoc4 ];
  meta = {
    description = "Qt PolicyKit bindings";
    license = "LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
