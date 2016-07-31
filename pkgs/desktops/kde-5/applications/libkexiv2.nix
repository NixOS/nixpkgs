{ kdeApp, lib, exiv2, ecm }:

kdeApp {
  name = "libkexiv2";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ exiv2 ];
}
