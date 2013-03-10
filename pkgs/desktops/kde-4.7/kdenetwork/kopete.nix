{ kde, kdelibs, speex, libmsn, libotr, kdepimlibs, qimageblitz, libktorrent,
  jasper, libidn, mediastreamer, msilbc, pkgconfig, libxml2, libxslt, giflib,
  libgadu, boost, qca2, gpgme, sqlite }:

kde {
  buildInputs = [ kdelibs speex libmsn libotr kdepimlibs qimageblitz libktorrent
    jasper libidn mediastreamer msilbc libxml2 libxslt giflib libgadu boost qca2
    gpgme sqlite ];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  patchPhase = "cp -v ${./FindmsiLBC.cmake} kopete/cmake/modules/FindmsiLBC.cmake";

  cmakeFlags = [ "-DBUILD_skypebuttons=TRUE" ];

  meta = {
    description = "A KDE multi-protocol IM client";
  };
}
