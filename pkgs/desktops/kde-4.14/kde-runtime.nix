{ kde, kdelibs, bzip2, libssh, exiv2, attica, qca2, shared_mime_info
, libcanberra, virtuoso, samba, libjpeg, ntrack, pkgconfig, xz, libpulseaudio
, networkmanager, kactivities, kdepimlibs, openexr, ilmbase, gpgme, glib
}:

kde {
  patches = [ ./CVE-2014-8600.diff ];

  buildInputs = [
    kdelibs attica xz bzip2 libssh libjpeg exiv2 ntrack
    qca2 samba libcanberra libpulseaudio gpgme
    networkmanager kactivities kdepimlibs openexr
#todo: add openslp
#todo: gpgme can't be found because cmake module is provided by kdepimlibs which are found too late
  ];

  nativeBuildInputs = [ shared_mime_info ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${glib.dev}/include/glib-2.0 -I${glib.out}/lib/glib-2.0/include";

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
