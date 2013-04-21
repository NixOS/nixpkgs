{ chmlib, djvulibre, ebook_tools, kde, kdelibs, libspectre, popplerQt4, qca2
, qimageblitz, libtiff, kactivities, pkgconfig }:

kde {

  #todo: package activeapp

  buildInputs =
    [ chmlib djvulibre ebook_tools kdelibs libspectre popplerQt4 qca2 qimageblitz libtiff kactivities ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = "GPLv2";
  };
}
