{ stdenv, kde, kdelibs, pkgconfig, doxygen, kdepimlibs, xapian, qjson, akonadi, kfilemetadata, boost
}:

kde {

# TODO: qmobipocket

  buildInputs = [
    kdelibs kdepimlibs xapian qjson akonadi kfilemetadata boost
  ];

  nativeBuildInputs = [ pkgconfig doxygen ];

  meta = {
    description = "Baloo";
    license = stdenv.lib.licenses.gpl2;
  };
}
