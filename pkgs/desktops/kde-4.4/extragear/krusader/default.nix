{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "krusader-2.0.0";
  src = fetchurl {
    url = mirror://sourceforge/krusader/krusader-2.0.0.tar.gz;
    sha256 = "dc74c47d6eaf1c28165a74750e5a1b0341fa1c0d436658d0d5f85a6149f4852c";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl gettext kdelibs automoc4 phonon ];
  patches = [./krusader-gcc44.patch];
  meta = {
    description = "Norton/Total Commander clone for KDE";
    license = "GPL";
    homepage = http://www.krusader.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
