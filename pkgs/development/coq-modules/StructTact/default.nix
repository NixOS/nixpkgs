{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "StructTact";
  owner = "uwplse";
  inherit version;
  defaultVersion = if versions.isGe "8.5" coq.coq-version then "20181102" else null;
  release."20181102".rev =    "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
  release."20181102".sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
  preConfigure = "patchShebangs ./configure";
}
