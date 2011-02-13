{ kde, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdepimlibs, gettext
, automoc4, phonon, akonadi, soprano, strigi}:

kde.package rec {
  name = with meta.kde; "${module}-${release}";

  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info kdelibs
    kdepimlibs automoc4 phonon akonadi soprano strigi gettext ];

  src = fetchurl {
    url = "mirror://kde/unstable/kdepim/${meta.kde.release}/src/${name}.tar.bz2";
    sha256 = "0gsp1yycjb7a3p285yqhs6v9rsrpbq0wfq3jhz7ky306692lrxig";
  };

  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    kde = {
      release = "4.5.94.1";
      module = "kdepim-runtime";
    };
  };
}
