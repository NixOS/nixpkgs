{ kde, fetchurl, cmake, kdelibs, libxml2, libxslt, boost, kdepimlibs, akonadi
, shared_desktop_ontologies }:

kde {
  buildInputs = [ kdepimlibs akonadi boost shared_desktop_ontologies libxml2
    libxslt ];

  patches = map fetchurl [ {
    # See https://bugs.kde.org/show_bug.cgi?id=289932
    url = "http://bugsfiles.kde.org/attachment.cgi?id=68763";
    name = "delays-in-nepomuk-indexing.patch";
    sha256 = "0j3ndqwvi4bg789jb0wqsh2zpwi1gwdyng9gdmng189dx409jf85";
  } ];

  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
  };
}
