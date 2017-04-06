{ kdeFramework, lib, extra-cmake-modules, qtsvg }:

kdeFramework {
  name = "breeze-icons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  outputs = [ "out" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtsvg ];
  propagatedUserEnvPkgs = [ qtsvg.out ];
}
