{
  kdeApp, lib,
  ecm, kio, libkexiv2, libkdcraw
}:

kdeApp {
  name = "kdegraphics-thumbnailers";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kio libkexiv2 libkdcraw ];
}
