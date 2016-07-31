{
  kdeApp, lib,
  ecm,
  boost, gpgme
}:

kdeApp {
  name = "gpgmepp";
  meta = {
    license = with lib.licenses; [ lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ boost gpgme ];
}
