{ kdeFramework, lib
, extra-cmake-modules
, qtbase, networkmanager
}:

kdeFramework {
  name = "networkmanager-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ networkmanager ];
}
