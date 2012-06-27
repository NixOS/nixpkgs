{ kde, kdelibs, qimageblitz }:

kde {
  buildInputs = [ kdelibs qimageblitz ];

  cmakeFlags = [ "-DBUILD_icons=TRUE" "-DBUILD_plasma=TRUE" ];

  meta = {
    description = "A KDE Eye-candy Application";
  };
}
