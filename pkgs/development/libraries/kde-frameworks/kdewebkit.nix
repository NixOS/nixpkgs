{ mkDerivation, extra-cmake-modules
, kconfig, kcoreaddons, kio, kparts, qtwebkit
}:

mkDerivation {
  pname = "kdewebkit";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kcoreaddons kio kparts ];
  propagatedBuildInputs = [ qtwebkit ];
  outputs = [ "out" "dev" ];
  cmakeFlags = [
    "-DBUILD_DESIGNERPLUGIN=OFF"
  ];
}
