{ kde, cmake, lib, perl, qt4, exiv2, lcms, saneBackends, libgphoto2
, libspectre, popplerQt4, djvulibre, chmlib, shared_mime_info, libXxf86vm
, kdelibs, automoc4, strigi, qimageblitz, soprano, qca2, ebook_tools }:

kde.package {

  buildInputs = [ cmake perl qt4 exiv2 lcms saneBackends libgphoto2 libspectre
    (popplerQt4.override { inherit qt4; }) chmlib shared_mime_info libXxf86vm
    kdelibs automoc4 strigi qimageblitz soprano qca2 djvulibre ebook_tools ];

  meta = {
    description = "KDE graphics utilities";
    longDescription = ''
      Contains various graphics utilities such as Gwenview image viewer and
      Okular  document reader.
    '';
    license = "GPL";
    kde = {
      name = "kdegraphics";
      version = "4.5.2";
    };
  };
}
