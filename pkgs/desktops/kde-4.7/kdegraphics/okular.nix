{ chmlib, djvulibre, ebook_tools, kde, kdelibs, libspectre, popplerQt4, qca2
, qimageblitz, pkgconfig }:

kde {
  buildInputs =
    [ chmlib djvulibre ebook_tools kdelibs libspectre popplerQt4 qca2 qimageblitz pkgconfig ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = "GPLv2";
  };
}
