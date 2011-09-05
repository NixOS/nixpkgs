{ kde, kdelibs, shared_desktop_ontologies, bzip2, xz, libssh, exiv2, attica
, libcanberra, virtuoso, makeWrapper, samba
}:

# TODO: Re-enable ntrack once it is fixed upstream

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 xz libssh exiv2 attica virtuoso
      makeWrapper samba (libcanberra.override { gtk = null; })
    ];

  meta = {
    license = "LGPL";
  };
}
