with import ../../../../. {};

let
  package-requests = stdenv.mkDerivation {
    name = "julia-package-requests.csv";

    __impure = true;

    buildInputs = [cacert gzip wget];

    buildCommand = ''
      wget https://julialang-logs.s3.amazonaws.com/public_outputs/current/package_requests.csv.gz
      gunzip package_requests.csv.gz
      ls -lh
      cp package_requests.csv $out
    '';
  };

  registry = callPackage ../registry.nix {};

in

runCommand "top-julia-packages.yaml" {
  __impure = true;
  nativeBuildInputs = [(python3.withPackages (ps: with ps; [pyyaml toml]))];
} ''
  python ${./process_top_n.py} ${package-requests} ${registry} > $out
''
