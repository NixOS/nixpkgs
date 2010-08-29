{ kde, cmake, kdelibs, qt4, kdepimlibs, akonadi, pkgconfig, boost, shared_mime_info, libxml2, shared_desktop_ontologies, soprano, strigi, automoc4, libxslt }:

kde.package rec {
	stable = false;
	subdir = "kdepim/${meta.kde.version}/src";

	buildInputs = [ automoc4 cmake kdelibs qt4 kdepimlibs akonadi pkgconfig boost shared_mime_info shared_desktop_ontologies libxml2 soprano strigi libxslt ];

  meta = {
    description = "Runtime files for KDE PIM: akonadi agents etc.";
    kde = {
      name = "kdepim-runtime";
      version = "4.4.92";
    };
  };
}
