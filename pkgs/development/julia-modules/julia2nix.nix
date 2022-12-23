{ writeScriptBin
, julia
}:

writeScriptBin "julia2nix"
  ''
  ${julia.withPackages (ps: with ps; [ ArgParse ])}/bin/julia -- ${./julia2nix.jl} "$@"
  ''
