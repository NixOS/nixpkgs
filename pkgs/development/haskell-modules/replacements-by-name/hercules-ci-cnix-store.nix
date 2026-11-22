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
  version = "0.4.2.0";
  sha256 = "9d7a41dcc3a3dc3b32ebe58e25b4aa6a634f6002b80ebd70c074e389b3e8d317";
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
  license = lib.meta.getLicenseFromSpdxId "Apache-2.0";
}
