{ kde, kdelibs, libktorrent, kde_workspace, kdepimlibs, sqlite
, shared_desktop_ontologies, kde_baseapps, gpgme, boost, libmms, qca2 }:

kde {
  buildInputs =
    [ kdelibs libktorrent kde_workspace shared_desktop_ontologies kdepimlibs
      kde_baseapps gpgme boost libmms qca2 sqlite
    ];

  KDEDIRS = libktorrent;

  patches = [ ./kdenetwork.patch ];
}
