{ kde, kdelibs, speex, libmsn, libotr, kdepimlibs, qimageblitz, libktorrent,
  jasper, libidn, mediastreamer, msilbc, pkgconfig, libxslt, giflib,
  libgadu, boost, qca2, gpgme, sqlite, telepathy_qt, shared_desktop_ontologies,
  libjpeg, libmms, ortp, srtp, libv4l}:

kde {

# TODO: libmeanwhile, xmms, jsoncpp
# commented out deps seem to not be needed anymore, but why so many?

  buildInputs = [
    kdelibs qca2 mediastreamer libgadu # telepathy_qt shared_desktop_ontologies  gpgme 
    kdepimlibs qimageblitz sqlite jasper libotr libmsn giflib # libktorrent libjpeg 
    libidn libxslt boost # speex  libmms msilbc
    ortp srtp libv4l
  ];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  cmakeFlags = [ "-DBUILD_skypebuttons=TRUE" ];

  meta = {
    description = "A KDE multi-protocol IM client";
  };
}
