{ boost
, extra-cmake-modules
, kdeApp
, kdesignerplugin
, kitemmodels
, lib
, mariadb
, postgresql
}:

kdeApp {
  name = "akonadi";
  meta = {
    description = "KDE PIM Storage Service";
    license = with lib.licenses; [ lgpl2 ];
    homepage = http://pim.kde.org/akonadi;
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    boost
    kdesignerplugin
    kitemmodels
  ];
  propagatedBuildInputs = [
    mariadb
    postgresql
  ];
}
