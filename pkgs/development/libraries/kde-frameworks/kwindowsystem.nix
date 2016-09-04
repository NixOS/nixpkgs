{ kdeFramework, lib
, ecm
, qtx11extras
}:

kdeFramework {
  name = "kwindowsystem";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtx11extras ];
}
