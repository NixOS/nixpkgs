{ stdenv, chmlib, djvulibre, ebook_tools, kde, kdelibs, libspectre, poppler_qt4, qca2
, qimageblitz, libtiff, kactivities, pkgconfig, libkexiv2 }:

kde {

# TODO: package activeapp, qmobipocket

  buildInputs = [ kdelibs chmlib djvulibre ebook_tools libspectre poppler_qt4
                  qca2 qimageblitz libtiff kactivities libkexiv2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = stdenv.lib.licenses.gpl2;
  };
}
