{ kdeFramework, lib, ecm, qtsvg }:

kdeFramework {
  name = "breeze-icons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  outputs = [ "out" ];
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtsvg ];
  propagatedUserEnvPkgs = [ qtsvg.out ];
}
