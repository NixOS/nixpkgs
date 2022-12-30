{ writeScriptBin
, julia
}:

writeScriptBin "julia2nix"
  ''
  ${julia}/bin/julia -- ${./julia2nix.jl} "$@"
  ''
