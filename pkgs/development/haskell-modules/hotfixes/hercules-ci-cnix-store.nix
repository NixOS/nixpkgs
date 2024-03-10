{ mkDerivation, base, boost, bytestring, Cabal
, cabal-pkg-config-version-hook, conduit, containers, exceptions
, hspec, hspec-discover, inline-c, inline-c-cpp, lib, nix
, protolude, template-haskell, temporary, text, unix, unliftio-core
, vector
}:
mkDerivation {
  pname = "hercules-ci-cnix-store";
  version = "0.3.5.0";
  sha256 = "395a311514ab5121bf71adc0f67a53b152a091114725fb750c08767a047c7280";
  setupHaskellDepends = [ base Cabal cabal-pkg-config-version-hook ];
  libraryHaskellDepends = [
    base bytestring conduit containers inline-c inline-c-cpp protolude
    template-haskell unix unliftio-core vector
  ];
  librarySystemDepends = [ boost ];
  libraryPkgconfigDepends = [ nix ];
  testHaskellDepends = [
    base bytestring containers exceptions hspec inline-c inline-c-cpp
    protolude temporary text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://docs.hercules-ci.com";
  description = "Haskell bindings for Nix's libstore";
  license = lib.licenses.asl20;
}
