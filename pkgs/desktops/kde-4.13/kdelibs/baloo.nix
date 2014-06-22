{ kde, kdelibs, pkgconfig, kdepimlibs, xapian, kfilemetadata, qjson
, akonadi, boost }:

kde {

# TODO: qmobipocket

  buildInputs = [
    kdelibs kdepimlibs xapian kfilemetadata qjson akonadi boost
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Baloo file searcher";
    license = "GPLv2";
  };
}
