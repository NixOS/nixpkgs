{ kdeFramework, lib, ecm, qtsvg }:

kdeFramework {
  name = "breeze-icons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  outputs = [ "out" ];
  nativeBuildInputs = [ ecm ];
  buildInputs = [ qtsvg ];
  propagatedUserEnvPkgs = [ qtsvg.out ];
}
