{ kde, kdelibs, shared_desktop_ontologies, bzip2, libssh, exiv2, attica
, libcanberra, virtuoso, samba, libjpeg, ntrack, pkgconfig, qca2, xz, pulseaudio
, networkmanager, kactivities, kdepimlibs
}:

kde {
  buildInputs = [
    kdelibs attica xz bzip2 libssh libjpeg exiv2 ntrack
    qca2 samba (libcanberra.override { gtk = null; }) pulseaudio
    networkmanager kactivities kdepimlibs
#todo: add openslp, openexr
  ];

  nativeBuildInputs = [ pkgconfig ];

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
