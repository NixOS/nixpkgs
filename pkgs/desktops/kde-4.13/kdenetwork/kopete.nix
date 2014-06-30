{ kde, kdelibs, libmsn, libotr, kdepimlibs, qimageblitz, libktorrent,
  jasper, libidn, mediastreamer, pkgconfig, libxslt, giflib,
  libgadu, boost, qca2, sqlite, jsoncpp,
  ortp, srtp, libv4l }:

kde {

# TODO: libmeanwhile, xmms, jsoncpp(not found), kleopatra(from kdepim but doesn't install headers?),

  buildInputs = [
    kdelibs qca2 mediastreamer libgadu jsoncpp
    kdepimlibs qimageblitz sqlite jasper libotr libmsn giflib
    libidn libxslt boost
    ortp srtp libv4l
  ];

  nativeBuildInputs = [ pkgconfig ];

  KDEDIRS = libktorrent;

  cmakeFlags = [ "-DBUILD_skypebuttons=TRUE" ];

  meta = {
    description = "A KDE multi-protocol IM client";
  };
}
