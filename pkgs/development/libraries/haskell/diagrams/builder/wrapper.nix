/*
  If user need access to more haskell package for building his
  diagrams, he simply has to pass these package through the
  extra packages function as follow in `config.nix`:
  
  ~~~
  diagramBuilderWrapper.override {
    extraPackages = self : [myHaskellPackage];
  }
  ­~~~

  WARNING:
  Note that this solution works well but however, as this is a 
  non-cabal derivation, user should be carefull to never put this
  package inside the listing passed as argument to `ghcWithPackages`
  as it will silently disregard the package. This silent disregard
  should be regarded as an issue for `ghcWithPackages`. It should
  rather raise an error instead when a non-cabal dirivation is
  directly passed to it. The alternative would have been to
  use a fake cabal file in order to make this a cabal derivation
  such as what `yiCustom` package did.
*/

{ stdenv, diagramsBuilder, ghcWithPackages, makeWrapper, 
  extraPackages ? (self: []) }:
let
  # Used same technique as for the yiCustom package.
  w = ghcWithPackages 
    (self: [ diagramsBuilder ] ++ extraPackages self);
  wrappedGhc = w.override { ignoreCollisions = true; };
in
stdenv.mkDerivation {
  name = diagramsBuilder.name + "-wrapper";
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper \
    "${diagramsBuilder}/bin/diagrams-builder-svg" "$out/bin/diagrams-builder-svg" \
      --set NIX_GHC ${wrappedGhc}/bin/ghc \
      --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${diagramsBuilder.ghc.version}

    makeWrapper \
    "${diagramsBuilder}/bin/diagrams-builder-cairo" "$out/bin/diagrams-builder-cairo" \
      --set NIX_GHC ${wrappedGhc}/bin/ghc \
      --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${diagramsBuilder.ghc.version}

    makeWrapper \
    "${diagramsBuilder}/bin/diagrams-builder-ps" "$out/bin/diagrams-builder-ps" \
    --set NIX_GHC ${wrappedGhc}/bin/ghc \
    --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${diagramsBuilder.ghc.version}
  '';
  preferLocalBuild = true;
  meta = diagramsBuilder.meta;
}