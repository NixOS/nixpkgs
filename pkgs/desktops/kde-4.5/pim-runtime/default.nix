{ kdePackage, cmake, kdelibs, qt4, kdepimlibs, akonadi, pkgconfig, boost, shared_mime_info, libxml2, shared_desktop_ontologies, soprano, strigi, automoc4, libxslt }:

kdePackage rec {
	pn = "kdepim-runtime";
	v = "4.4.92";
	stable = false;
	subdir = "kdepim/${v}/src";

	buildInputs = [ automoc4 cmake kdelibs qt4 kdepimlibs akonadi pkgconfig boost shared_mime_info shared_desktop_ontologies libxml2 soprano strigi libxslt ];

  meta = {
    description = "Runtime files for KDE PIM: akonadi agents etc.";
  };
}
