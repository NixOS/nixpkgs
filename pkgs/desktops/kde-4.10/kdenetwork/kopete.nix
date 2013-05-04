{ kde, kdelibs, speex, libmsn, libotr, kdepimlibs, qimageblitz, libktorrent,
  jasper, libidn, mediastreamer, msilbc, pkgconfig, libxslt, giflib,
  libgadu, boost, qca2, gpgme, sqlite, telepathy_qt, shared_desktop_ontologies,
  libjpeg, nepomuk_core, libmms }:

kde {
#todo: libmeanwhile, xmms
  buildInputs = [
    kdelibs telepathy_qt shared_desktop_ontologies qca2 gpgme libgadu mediastreamer
    kdepimlibs qimageblitz libktorrent libjpeg sqlite jasper giflib libmsn libotr
    libxslt libidn speex nepomuk_core boost libmms msilbc
];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  patchPhase =
    ''
      cp -v ${./FindmsiLBC.cmake} kopete/cmake/modules/FindmsiLBC.cmake
    '';

  cmakeFlags = [ "-DBUILD_skypebuttons=TRUE" ];

  meta = {
    description = "A KDE multi-protocol IM client";
  };
}
