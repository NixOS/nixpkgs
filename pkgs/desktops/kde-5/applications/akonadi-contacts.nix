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
, qtwebengine
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
    akonadi.unwrapped
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
    qtwebengine
  ];
}
