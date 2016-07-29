{ kdeFramework, lib
, extra-cmake-modules
, networkmanager
}:

kdeFramework {
  name = "networkmanager-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager ];
}
