{ kde, pkgconfig, kdepimlibs, xapian, kfilemetadata, boost, akonadi, qjson }:

kde {

  buildInputs = [
    kdepimlibs xapian kfilemetadata boost akonadi qjson
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Baloo file searcher";
    license = "GPLv2";
  };
}
