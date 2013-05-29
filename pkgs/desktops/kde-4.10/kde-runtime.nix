{ kde, kdelibs, shared_desktop_ontologies, bzip2, libssh, exiv2, attica
, libcanberra, virtuoso, samba, libjpeg, ntrack, pkgconfig, qca2, xz, pulseaudio
, networkmanager, kactivities, kdepimlibs, openexr, ilmbase
}:

kde {
  buildInputs = [
    kdelibs attica xz bzip2 libssh libjpeg exiv2 ntrack
    qca2 samba (libcanberra.override { gtk = null; }) pulseaudio
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
