{ kde, kdelibs, speex, libmsn, libotr, kdepimlibs, qimageblitz, libktorrent,
  jasper, libidn, mediastreamer, msilbc, pkgconfig, libxslt, giflib,
  libgadu, boost, qca2, gpgme, sqlite, telepathy_qt, shared_desktop_ontologies,
  libjpeg, libmms }:

kde {
#todo: libmeanwhile, xmms
  buildInputs = [
    kdelibs telepathy_qt shared_desktop_ontologies qca2 gpgme libgadu mediastreamer
    kdepimlibs qimageblitz libktorrent libjpeg sqlite jasper giflib libmsn libotr
    libxslt libidn speex boost libmms msilbc
];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  patchPhase =
    ''
      cp -v ${./FindmsiLBC.cmake} kopete/cmake/modules/FindmsiLBC.cmake
      patch -p1 < ${./kopete-4.10.4-kopete-linphonemediaengine.patch}
      patch -p1 < ${./kopete-4.10.4-kopete-stun.patch}
      patch -p1 < ${./kopete-giflib5.patch}
    '';

  cmakeFlags = [ "-DBUILD_skypebuttons=TRUE" ];

  meta = {
    description = "A KDE multi-protocol IM client";
  };
}
