{ kdeFramework, lib
, extra-cmake-modules
, qtbase, networkmanager
}:

kdeFramework {
  name = "networkmanager-qt";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ networkmanager ];
}
