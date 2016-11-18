{ akonadi
, akonadi-mime
, boost
, ecm
, grantlee
, kdeApp
, kcalcore
, kcontacts
, kdelibs4support
, kdoctools
, kio
, kmime
, lib
, libical
, qt5
}:

kdeApp {
  name = "akonadi-contacts";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi
    akonadi-mime
    boost
    grantlee
    kcalcore
    kcontacts
    kdelibs4support
    kdoctools
    kio
    kmime
    libical
    qt5.qtwebengine
  ];
}
