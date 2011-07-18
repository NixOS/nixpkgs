{ automoc4, chmlib, cmake, djvulibre, ebook_tools, kde, kdelibs, libspectre
, popplerQt4, qca2, qimageblitz, qt4, phonon }:

kde.package {

  buildInputs =
    [ automoc4 chmlib cmake djvulibre ebook_tools kdelibs libspectre popplerQt4
      qca2 qimageblitz qt4 phonon
    ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = "GPLv2";
    kde.name = "okular";
  };
}
