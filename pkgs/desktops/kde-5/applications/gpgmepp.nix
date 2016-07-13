{ kdeApp
, lib
, extra-cmake-modules
, boost
, gpgme
}:

kdeApp {
  name = "gpgmepp";
  meta = {
    license = with lib.licenses; [ lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    boost gpgme
  ];
}
