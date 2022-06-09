{ stdenv
, pkgs
, lib

# set to true for a much smaller closure (2 builds instead of 121) at
# the expense of risky version-constraint jailbreaking
, useJailbreak ? false
}:

# purescript requires GHC 8.10.7
(pkgs.haskell.packages.ghc8107.override {
  overrides = final: prev: {
    # bower-json 1.0.0.1 requires the use of aeson 1.5.6.0
    aeson = final.aeson_1_5_6_0;
    purescript =
      let purescript = (final.callPackage generated/purescript.nix { });
      in if !useJailbreak
         then
           # purescript hardwires process==1.6.13.1, whereas
           # hackage2nix-main.yml sets process==1.6.13.2 as part of
           # the "core" which apparently are unaffected by override.
           pkgs.haskell.lib.compose.allowInconsistentDependencies
             purescript
         else (pkgs.haskell.lib.compose.doJailbreak purescript)
           .override {
             bower-json = final.callPackage generated/bower-json.nix { };
           };
  } // lib.optionalAttrs (!useJailbreak) {
    language-javascript = final.callPackage generated/language-javascript.nix { };
    process = final.callPackage generated/process.nix { };
    semialign = final.callPackage generated/semialign.nix { };
    bower-json = final.callPackage generated/bower-json.nix { };
    witherable = final.callPackage generated/witherable.nix { };
    vector = pkgs.haskell.lib.compose.dontCheck (final.callPackage generated/vector.nix { });
    lens = pkgs.haskell.lib.compose.dontCheck (final.callPackage generated/lens.nix { });
    memory = final.callPackage generated/memory.nix { };
  };

}).purescript.overrideAttrs (_: {
  pname = "purescript";
  version = "0.15.2";

  postInstall = ''
    PURS="$out/bin/purs"
    mkdir -p $out/share/bash-completion/completions
    $PURS --bash-completion-script $PURS > $out/share/bash-completion/completions/purs-completion.bash
  '';

  passthru = {
    updateScript = ./generate.sh;
    tests = {
      minimal-module = pkgs.callPackage ./test-minimal-module {};
    };
  };

  meta = with lib; {
    description = "A strongly-typed functional programming language that compiles to JavaScript";
    homepage = "https://www.purescript.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ justinwoo mbbx6spp cdepillabout ];
    mainProgram = "purs";
    changelog = "https://github.com/purescript/purescript/releases/tag/v${version}";
    sourceProvenance = [ ];
  };
})
