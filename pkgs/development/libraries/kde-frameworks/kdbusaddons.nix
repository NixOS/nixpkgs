{ kdeFramework, lib, ecm, qtx11extras }:

kdeFramework {
  name = "kdbusaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtx11extras ];
}
