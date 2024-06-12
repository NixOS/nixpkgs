{ mkDerivation, aeson, async, attoparsec, base, base64-bytestring
, bifunctors, binary, binary-conduit, boost, bytestring, Cabal
, cabal-pkg-config-version-hook, cachix, cachix-api, conduit
, conduit-extra, containers, directory, dlist, exceptions
, file-embed, filepath, hercules-ci-api, hercules-ci-api-agent
, hercules-ci-api-core, hercules-ci-cnix-expr
, hercules-ci-cnix-store, hostname, hspec, hspec-discover
, http-client, http-client-tls, http-conduit, HUnit, inline-c
, inline-c-cpp, katip, lens, lens-aeson, lib, lifted-async
, lifted-base, monad-control, mtl, network, network-uri, nix
, optparse-applicative, process, process-extras, profunctors
, protolude, QuickCheck, safe-exceptions, scientific, servant
, servant-auth-client, servant-client, servant-client-core, stm
, tagged, temporary, text, time, tls, tomland, transformers
, transformers-base, unbounded-delays, unix, unliftio
, unliftio-core, unordered-containers, uuid, vector, websockets
, wuss
}:
mkDerivation {
  pname = "hercules-ci-agent";
  version = "0.10.4";
  sha256 = "8daf98cb6817bc08cc1bcde0275fb9c4dc1727449b3d797a99e64ed009be54af";
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal cabal-pkg-config-version-hook ];
  libraryHaskellDepends = [
    aeson async base binary binary-conduit bytestring conduit
    containers directory dlist exceptions file-embed filepath
    hercules-ci-api-agent hercules-ci-api-core hercules-ci-cnix-expr
    hercules-ci-cnix-store katip lens lens-aeson lifted-async
    lifted-base monad-control mtl network network-uri process
    process-extras protolude safe-exceptions stm tagged temporary text
    time tls transformers transformers-base unbounded-delays unix
    unliftio unliftio-core uuid vector websockets wuss
  ];
  executableHaskellDepends = [
    aeson async attoparsec base base64-bytestring bifunctors binary
    binary-conduit bytestring cachix cachix-api conduit conduit-extra
    containers directory dlist exceptions filepath hercules-ci-api
    hercules-ci-api-agent hercules-ci-api-core hercules-ci-cnix-expr
    hercules-ci-cnix-store hostname http-client http-client-tls
    http-conduit inline-c inline-c-cpp katip lens lens-aeson
    lifted-async lifted-base monad-control mtl network network-uri
    optparse-applicative process process-extras profunctors protolude
    safe-exceptions scientific servant servant-auth-client
    servant-client servant-client-core stm temporary text time tomland
    transformers transformers-base unix unliftio unliftio-core
    unordered-containers uuid vector websockets wuss
  ];
  executableSystemDepends = [ boost ];
  executablePkgconfigDepends = [ nix ];
  testHaskellDepends = [
    aeson async attoparsec base bifunctors binary binary-conduit
    bytestring conduit containers exceptions filepath
    hercules-ci-api-agent hercules-ci-api-core hercules-ci-cnix-store
    hspec HUnit katip lens lens-aeson lifted-async lifted-base
    monad-control mtl process profunctors protolude QuickCheck
    safe-exceptions scientific stm tagged temporary text tomland
    transformers transformers-base unliftio-core unordered-containers
    uuid vector
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://docs.hercules-ci.com";
  description = "Runs Continuous Integration tasks on your machines";
  license = lib.licenses.asl20;
}
