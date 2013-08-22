{ kde, kdelibs, qimageblitz, python }:

kde {
  buildInputs = [ kdelibs qimageblitz python ];

  cmakeFlags = [ "-DBUILD_icons=TRUE" "-DBUILD_plasma=TRUE" ];

  meta = {
    description = "A KDE Eye-candy Application";
  };
}
