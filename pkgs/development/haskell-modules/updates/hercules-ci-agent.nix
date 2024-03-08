{ mkDerivation, aeson, async, attoparsec, base, base64-bytestring
, binary, binary-conduit, boost, bytestring, Cabal
, cabal-pkg-config-version-hook, cachix, cachix-api, conduit
, conduit-extra, containers, directory, dlist, exceptions, filepath
, hercules-ci-api, hercules-ci-api-agent, hercules-ci-api-core
, hercules-ci-cnix-expr, hercules-ci-cnix-store, hostname, hspec
, hspec-discover, http-client, http-client-tls, http-conduit
, inline-c, inline-c-cpp, katip, lens, lens-aeson, lib
, lifted-async, lifted-base, monad-control, mtl, network
, network-uri, nix, optparse-applicative, process, process-extras
, protolude, safe-exceptions, scientific, servant
, servant-auth-client, servant-client, servant-client-core, stm
, tagged, temporary, text, time, tomland, transformers
, transformers-base, unbounded-delays, unix, unliftio
, unliftio-core, unordered-containers, uuid, vector, websockets
, wuss
}:
mkDerivation {
  pname = "hercules-ci-agent";
  version = "0.9.13";
  sha256 = "1904fcef04d3358d86731a2533d16146a5f19ee13a83fbe94faa670220525b21";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  setupHaskellDepends = [ base Cabal cabal-pkg-config-version-hook ];
  libraryHaskellDepends = [
    aeson async base binary binary-conduit bytestring conduit
    containers directory dlist exceptions filepath
    hercules-ci-api-agent hercules-ci-api-core hercules-ci-cnix-expr
    hercules-ci-cnix-store katip lens lens-aeson lifted-async
    lifted-base monad-control mtl network network-uri process
    process-extras protolude safe-exceptions stm tagged temporary text
    time transformers transformers-base unbounded-delays unix unliftio
    unliftio-core uuid websockets wuss
  ];
  executableHaskellDepends = [
    aeson async attoparsec base base64-bytestring binary binary-conduit
    bytestring cachix cachix-api conduit conduit-extra containers
    directory dlist exceptions filepath hercules-ci-api
    hercules-ci-api-agent hercules-ci-api-core hercules-ci-cnix-expr
    hercules-ci-cnix-store hostname http-client http-client-tls
    http-conduit inline-c inline-c-cpp katip lens lens-aeson
    lifted-async lifted-base monad-control mtl network network-uri
    optparse-applicative process process-extras protolude
    safe-exceptions scientific servant servant-auth-client
    servant-client servant-client-core stm temporary text time tomland
    transformers transformers-base unix unliftio unliftio-core
    unordered-containers uuid vector websockets wuss
  ];
  executableSystemDepends = [ boost ];
  executablePkgconfigDepends = [ nix ];
  testHaskellDepends = [
    aeson async attoparsec base binary binary-conduit bytestring
    conduit containers exceptions filepath hercules-ci-api-agent
    hercules-ci-api-core hercules-ci-cnix-store hspec katip
    lifted-async lifted-base monad-control mtl process protolude
    safe-exceptions stm tagged temporary text transformers-base
    unliftio-core vector
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://docs.hercules-ci.com";
  description = "Runs Continuous Integration tasks on your machines";
  license = lib.licenses.asl20;
}
