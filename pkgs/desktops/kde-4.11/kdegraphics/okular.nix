{ chmlib, djvulibre, ebook_tools, kde, kdelibs, libspectre, popplerQt4, qca2
, qimageblitz, libtiff, kactivities, pkgconfig }:

kde {

# TODO: package activeapp

  buildInputs =
    [ kdelibs chmlib djvulibre ebook_tools libspectre popplerQt4 qca2 qimageblitz libtiff kactivities ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Okular, the KDE document viewer";
    license = "GPLv2";
  };
}
