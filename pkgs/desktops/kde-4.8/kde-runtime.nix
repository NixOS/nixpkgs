{ kde, kdelibs, shared_desktop_ontologies, bzip2, libssh, exiv2, attica
, libcanberra, virtuoso, samba, libjpeg, ntrack, pkgconfig, qca2, xz, pulseaudio
, networkmanager
}:

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 libssh exiv2 attica xz networkmanager
      samba (libcanberra.override { gtk = null; }) ntrack libjpeg qca2 pulseaudio
    ];

  nativeBuildInputs = [ pkgconfig ];

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
