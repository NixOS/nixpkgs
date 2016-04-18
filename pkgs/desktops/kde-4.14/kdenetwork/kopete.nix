{ kde, kdelibs, libmsn, libotr, kdepimlibs, qimageblitz, libktorrent,
  jasper, libidn, mediastreamer, pkgconfig, libxslt, giflib,
  libgadu, boost, qca2, sqlite, jsoncpp,
  ortp, srtp, libv4l, fetchurl }:

kde {

# TODO: libmeanwhile, xmms, jsoncpp(not found), kleopatra(from kdepim but doesn't install headers?),

  patches = [
    (fetchurl {
      name = "kopete.patch";
      url = "https://bugs.kde.org/attachment.cgi?id=91567";
      sha256 = "0a44rjiqzn6v3sywm17d1741sygbvlfnbqadq7qbdj3amny014m1";
    })
  ];

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
