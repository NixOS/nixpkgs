{ lib, mkCoqDerivation, coq, Vpl, version ? null }:

mkCoqDerivation {
  pname = "VplTactic";
  owner = "VERIMAG-Polyhedra";
  defaultVersion = if lib.versions.isEq "8.9" coq.version then "0.5" else null;

  release."0.5".rev = "487e3aff8446bed2c5116cefc7d71d98a06e85de";
  release."0.5".sha256 = "sha256-4h0hyvj9R+GOgnGWQFDi0oENLZPiJoimyK1q327qvIY=";

  buildInputs = [ coq.ocamlPackages.vpl-core ];
  propagatedBuildInputs = [ Vpl ];
  mlPlugin = true;

  meta = Vpl.meta // {
    description = "A Coq Tactic for Arithmetic (based on VPL)";
  };
}
