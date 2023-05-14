{ lib, buildDunePackage, fetchFromGitHub, stdune, dyn }:

buildDunePackage rec {
  pname = "fiber";
  version = "unstable-2023-02-28";

  src = fetchFromGitHub {
    owner = "ocaml-dune";
    repo = "fiber";
    rev = "5563b588c1313f128eafa74d66f0626c9128d34d";
    hash = "sha256-18GfGXpu+uiIiCuLhIx5z5jRkem1nNWaQB6Ms0AE9sE=";
  };

  duneVersion = "3";

  buildInputs = [ stdune dyn ];

  meta = with lib; {
    description = "Structured concurrency library";
    homepage = "https://github.com/ocaml-dune/fiber";
    maintainers = with lib.maintainers; [ ];
    license = licenses.mit;
  };
}
