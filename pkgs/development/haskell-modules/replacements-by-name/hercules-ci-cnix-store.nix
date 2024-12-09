{
  mkDerivation,
  base,
  boost,
  bytestring,
  Cabal,
  cabal-pkg-config-version-hook,
  conduit,
  containers,
  exceptions,
  hspec,
  hspec-discover,
  inline-c,
  inline-c-cpp,
  lib,
  nix,
  protolude,
  template-haskell,
  temporary,
  text,
  unix,
  unliftio-core,
  vector,
}:
mkDerivation {
  pname = "hercules-ci-cnix-store";
  version = "0.3.6.1";
  sha256 = "35e3d21f9bbc1c83187af22a2532d227fc42a5cf3cf683a86be7bb7180f10d5e";
  setupHaskellDepends = [
    base
    Cabal
    cabal-pkg-config-version-hook
  ];
  libraryHaskellDepends = [
    base
    bytestring
    conduit
    containers
    inline-c
    inline-c-cpp
    protolude
    template-haskell
    unix
    unliftio-core
    vector
  ];
  librarySystemDepends = [ boost ];
  libraryPkgconfigDepends = [ nix ];
  testHaskellDepends = [
    base
    bytestring
    containers
    exceptions
    hspec
    inline-c
    inline-c-cpp
    protolude
    temporary
    text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://docs.hercules-ci.com";
  description = "Haskell bindings for Nix's libstore";
  license = lib.licenses.asl20;
}
