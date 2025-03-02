{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  containers,
}:

buildDunePackage rec {
  pname = "tsort";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = "ocaml-tsort";
    rev = version;
    sha256 = "sha256-SCd0R8iGwMeRhhSxMid9lzqj5fm+owCJ2dzwtLpFqB4=";
  };

  propagatedBuildInputs = [ containers ];

  meta = {
    description = "Easy to use and user-friendly topological sort";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
