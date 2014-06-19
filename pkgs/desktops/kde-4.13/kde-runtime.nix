{ kde, kdelibs, bzip2, libssh, exiv2, attica, qca2
, libcanberra, virtuoso, samba, libjpeg, ntrack, pkgconfig, xz, pulseaudio
, networkmanager, kactivities, kdepimlibs, openexr, ilmbase, gpgme
}:

kde {
  buildInputs = [
    kdelibs attica xz bzip2 libssh libjpeg exiv2 ntrack
    qca2 samba libcanberra pulseaudio gpgme
    networkmanager kactivities kdepimlibs openexr
#todo: add openslp
#todo: gpgme can't be found because cmake module is provided by kdepimlibs which are found too late
  ];

  nativeBuildInputs = [ pkgconfig ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
