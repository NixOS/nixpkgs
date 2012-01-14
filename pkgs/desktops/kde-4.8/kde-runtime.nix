{ kde, kdelibs, shared_desktop_ontologies, bzip2, xz, libssh, exiv2, attica
, libcanberra, virtuoso, samba, ntrack, libjpeg
}:

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 xz libssh exiv2 attica
      samba (libcanberra.override { gtk = null; }) ntrack libjpeg
    ];

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
