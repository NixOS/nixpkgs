{
  stdenv,
  haskellPackages,
  makeWrapper,
  packages ? (pkgSet: [ ]),
  nixosTests,
}:

let
  termonadEnv = haskellPackages.ghcWithPackages (self: [ self.termonad ] ++ packages self);
in
stdenv.mkDerivation {
  pname = "termonad-with-packages";
  inherit (termonadEnv) version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin $out/share
    makeWrapper ${termonadEnv}/bin/termonad $out/bin/termonad \
      --set NIX_GHC "${termonadEnv}/bin/ghc"
  '';

  # trivial derivation
  preferLocalBuild = true;
  allowSubstitutes = false;

  passthru.tests.test = nixosTests.terminal-emulators.termonad;

  meta = haskellPackages.termonad.meta // {
    mainProgram = "termonad";
  };
}
