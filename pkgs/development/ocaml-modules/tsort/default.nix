{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  containers,
}:

buildDunePackage rec {
  pname = "tsort";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = "ocaml-tsort";
    rev = version;
    sha256 = "sha256-/gxjXDRhQdbt0ZBdCNk/j1oWhAbm2UOfye2D9QvPr3o=";
  };

  propagatedBuildInputs = [ containers ];

  meta = {
    description = "Easy to use and user-friendly topological sort";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
