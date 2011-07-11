{ automoc4, chmlib, cmake, djvulibre, ebook_tools, kde, kdelibs, libspectre
, popplerQt4, qca2, qimageblitz, qt4 }:

kde.package {

  buildInputs =
    [ automoc4 chmlib cmake djvulibre ebook_tools kdelibs libspectre popplerQt4
      qca2 qimageblitz qt4
    ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = "GPLv2";
    kde.name = "okular";
  };
}
