{ kdeFramework, lib
, ecm
, qtx11extras
}:

kdeFramework {
  name = "kguiaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtx11extras ];
}
