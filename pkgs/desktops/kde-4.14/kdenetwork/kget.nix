{ kde, kdelibs, libktorrent, kde_workspace, sqlite, boost
, kde_baseapps, libmms, qca2, nepomuk_core, nepomuk_widgets
, pkgconfig }:

kde {

# TODO: QGpgME

  buildInputs =
    [ kdelibs libktorrent nepomuk_core nepomuk_widgets sqlite qca2
      libmms kde_baseapps kde_workspace boost ];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  meta = {
    description = "KDE download manager";
  };
}
