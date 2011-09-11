{ kde, kdelibs, shared_desktop_ontologies, bzip2, xz, libssh, exiv2, attica
, libcanberra, virtuoso, samba
}:

# TODO: Re-enable ntrack once it is fixed upstream

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 xz libssh exiv2 attica
      samba (libcanberra.override { gtk = null; })
    ];

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  meta = {
    license = "LGPL";
  };
}
