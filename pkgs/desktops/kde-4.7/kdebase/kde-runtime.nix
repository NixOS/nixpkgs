{ kde, kdelibs, shared_desktop_ontologies, bzip2, xz, libssh, exiv2, attica,
  libcanberra, virtuoso, makeWrapper, samba, ntrack
}:

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 xz libssh exiv2 attica virtuoso
    makeWrapper samba ntrack (libcanberra.override { gtk = null; })
    ];

# Copied from kde45, Nepomuk needs it.
  postInstall = ''
    wrapProgram "$out/bin/nepomukservicestub" --prefix LD_LIBRARY_PATH : "${virtuoso}/lib" \
        --prefix PATH : "${virtuoso}/bin"
  '';

  meta = {
    license = "LGPL";
  };
}
