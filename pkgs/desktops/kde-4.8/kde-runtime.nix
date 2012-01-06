{ kde, kdelibs, shared_desktop_ontologies, bzip2, xz, libssh, exiv2, attica
, libcanberra, virtuoso, samba, ntrack
}:

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 xz libssh exiv2 attica
      samba (libcanberra.override { gtk = null; }) ntrack
    ];

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
