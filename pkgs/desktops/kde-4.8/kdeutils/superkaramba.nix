{ kde, kdelibs, qimageblitz }:

kde {
  buildInputs = [ kdelibs qimageblitz ];

  cmakeFlags = [ "-DBUILD_icons=TRUE" "-DBULD_plasma=TRUE" ];

  meta = {
    description = "A KDE Eye-candy Application";
  };
}
