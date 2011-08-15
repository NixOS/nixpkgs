{ kde, kdelibs, libktorrent, kde_workspace, kdepimlibs, kdebase,
  shared_desktop_ontologies, kde_baseapps, gpgme, boost, libmms, qca2 }:

kde {
  buildInputs = [ kdelibs libktorrent kde_workspace kdebase
    shared_desktop_ontologies kdepimlibs kde_baseapps gpgme boost libmms qca2 ];

  KDEDIRS = libktorrent;

  patches = [ ./kdenetwork.patch ];
}
