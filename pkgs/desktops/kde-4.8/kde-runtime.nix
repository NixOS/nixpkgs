{ kde, kdelibs, shared_desktop_ontologies, bzip2, libssh, exiv2, attica
, libcanberra, virtuoso, samba, ntrack, libjpeg, fetchurl
}:

kde {
  buildInputs =
    [ kdelibs shared_desktop_ontologies bzip2 libssh exiv2 attica
      samba (libcanberra.override { gtk = null; }) ntrack libjpeg
    ];

  passthru.propagatedUserEnvPackages = [ virtuoso ];

  patches = map fetchurl [{
    # See https://bugs.kde.org/show_bug.cgi?id=289932
    url = "http://bugsfiles.kde.org/attachment.cgi?id=69386";
    name = "resourceidentifier.patch";
    sha256 = "1fpjg1yc191i6ga9sz6r530q9zwh790m3qahsp0i6kzajwpi7jwz";
  }];

  meta = {
    license = "LGPL";
  };
}
