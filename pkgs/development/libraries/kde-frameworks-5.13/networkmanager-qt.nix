{ mkDerivation, lib
, extra-cmake-modules
, networkmanager
}:

mkDerivation {
  name = "networkmanager-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ networkmanager ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
