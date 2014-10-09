{ stdenv, kde, kdelibs, pkgconfig, doxygen, kdepimlibs, xapian, qjson, akonadi, kfilemetadata
}:

kde {

# TODO: qmobipocket

  buildInputs = [
    kdelibs kdepimlibs xapian qjson akonadi kfilemetadata
  ];

  nativeBuildInputs = [ pkgconfig doxygen ];

  meta = {
    description = "Baloo";
    license = stdenv.lib.licenses.gpl2;
  };
}
