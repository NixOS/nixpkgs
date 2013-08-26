{ kde, kdelibs, bzip2, libssh, exiv2, attica, qca2
, libcanberra, virtuoso, samba, libjpeg, ntrack, pkgconfig, xz, pulseaudio
, networkmanager, kactivities, kdepimlibs, openexr, ilmbase
}:

kde {
  buildInputs = [
    kdelibs attica xz bzip2 libssh libjpeg exiv2 ntrack
    qca2 samba libcanberra pulseaudio
    networkmanager kactivities kdepimlibs openexr
#todo: add openslp
  ];

  nativeBuildInputs = [ pkgconfig ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
