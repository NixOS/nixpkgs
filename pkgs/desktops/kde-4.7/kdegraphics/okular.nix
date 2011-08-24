{ chmlib, djvulibre, ebook_tools, kde, kdelibs, libspectre, popplerQt4, qca2
, qimageblitz }:

kde {
  buildInputs =
    [ chmlib djvulibre ebook_tools kdelibs libspectre popplerQt4 qca2 qimageblitz ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = "GPLv2";
  };
}
