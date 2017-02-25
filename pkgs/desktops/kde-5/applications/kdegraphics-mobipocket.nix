{
  kdeApp, lib,
  ecm,
  kio
}:

kdeApp {
  name = "kdegraphics-mobipocket";
  meta = {
    license = [ lib.licenses.gpl2Plus ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  buildInputs = [ kio ];
}
