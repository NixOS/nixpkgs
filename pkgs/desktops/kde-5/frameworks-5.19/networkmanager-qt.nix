{ kdeFramework, lib
, extra-cmake-modules
, networkmanager
}:

kdeFramework {
  name = "networkmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
