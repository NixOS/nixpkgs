{ chmlib, djvulibre, ebook_tools, kde, kdelibs, libspectre, popplerQt4, qca2
, qimageblitz, libtiff, kactivities, pkgconfig, libkexiv2, stdenv, kdegraphics_mobipocket }:

kde {

# TODO: package activeapp, qmobipocket

  buildInputs = [ kdelibs chmlib djvulibre ebook_tools libspectre popplerQt4
                  qca2 qimageblitz libtiff kactivities libkexiv2 kdegraphics_mobipocket ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = stdenv.lib.licenses.gpl2;
  };
}
