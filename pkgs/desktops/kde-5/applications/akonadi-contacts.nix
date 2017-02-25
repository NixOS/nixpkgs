{
  kdeApp, lib,
  ecm,
  akonadi-mime, grantlee, kcontacts, kio, kitemmodels, kmime, qtwebengine,
  akonadi
}:

kdeApp {
  name = "akonadi-contacts";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  buildInputs = [
    akonadi-mime grantlee kcontacts kio kitemmodels kmime qtwebengine
  ];
  propagatedBuildInputs = [ akonadi ];
}
