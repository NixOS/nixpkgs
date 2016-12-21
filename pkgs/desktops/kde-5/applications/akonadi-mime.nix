{
  kdeApp, lib,
  ecm,
  akonadi, kdbusaddons, kio, kitemmodels, kmime
}:

kdeApp {
  name = "akonadi-mime";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  buildInputs = [ akonadi kdbusaddons kio kitemmodels kmime ];
}
