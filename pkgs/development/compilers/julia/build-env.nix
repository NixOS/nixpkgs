{ buildEnv
, makeWrapper
, extraPackages ? []
, julia
}:

buildEnv {
  name = "julia-env";
  paths = extraPackages;

  nativeBuildInputs = [ makeWrapper ];

  pathsToLink = [ "/share/julia" ];

  postBuild = ''
      makeWrapper ${julia}/bin/julia $out/bin/julia \
        --set JULIA_LOAD_PATH "$JULIA_LOAD_PATH:$out/share/julia/packages" \
        --set JULIA_DEPOT_PATH "$JULIA_DEPOT_PATH:$out/share/julia"
    '';

  passthru = { inherit julia; };
}
