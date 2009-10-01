{stdenv, fetchurl, cmake, qt4, policykit, automoc4, lib}:

stdenv.mkDerivation {
  name = "polkit-qt-0.9.2";
  src = fetchurl {
    url = mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-0.9.2.tar.bz2;
    sha256 = "1knlnmv9qg2i6j03rfj0xc5m5hgxdmr5ir67wjn089lwgjy83chk";
  };
  includeAllQtDirs = true;
  buildInputs = [ cmake qt4 policykit automoc4 ];
  meta = {
    description = "Qt PolicyKit bindings";
    license = "LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
