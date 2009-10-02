{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kde-l10n-ca-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kde-l10n/kde-l10n-ca-4.3.1.tar.bz2;
    sha256 = "1jvsl9gv9ksijfp1pfsvhnb7yjl7cdnvg9vzmz18a9r4wbah6w5m";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl gettext kdelibs automoc4 phonon ];
  cmakeFlagsArray = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  meta = {
    description = "KDE l10n for Catalan";
    license = "GPL";
    homepage = http://www.kde.org;
  };
}
