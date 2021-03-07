{ mkDerivation, lib
, extra-cmake-modules
, qtbase, qtx11extras, wayland
}:

mkDerivation {
  name = "kguiaddons";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras wayland ];
  propagatedBuildInputs = [ qtbase ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    maintainers = [ maintainers.ttuegel ];
    broken = versionOlder qtbase.version "5.14.0";
  };
}
