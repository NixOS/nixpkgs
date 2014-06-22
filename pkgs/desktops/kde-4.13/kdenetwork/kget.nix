{ kde, kdelibs, libktorrent, kde_workspace, sqlite, boost
, kde_baseapps, libmms, qca2, baloo, baloo_widgets
, pkgconfig }:

kde {

# TODO: QGpgME

  buildInputs =
    [ kdelibs libktorrent baloo baloo_widgets sqlite qca2
      libmms kde_baseapps kde_workspace boost ];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  meta = {
    description = "KDE download manager";
  };
}
