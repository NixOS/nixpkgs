{ mkDerivation, aeson, base, bytestring, containers, cookie
, exceptions, hashable, hercules-ci-api-core, hspec, http-api-data
, http-media, lens, lens-aeson, lib, memory, network-uri
, profunctors, protolude, QuickCheck, quickcheck-classes, servant
, servant-auth, servant-auth-swagger, servant-swagger
, servant-swagger-ui-core, string-conv, swagger2, text, time, uuid
, vector
}:
mkDerivation {
  pname = "hercules-ci-api";
  version = "0.8.1.0";
  sha256 = "d1b802c9db7efde7eed46663dea7d860b2560c5fe44354d0d6e8745ed1e1fb8f";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers cookie exceptions hashable
    hercules-ci-api-core http-api-data http-media lens lens-aeson
    memory network-uri profunctors servant servant-auth
    servant-auth-swagger servant-swagger servant-swagger-ui-core
    string-conv swagger2 text time uuid
  ];
  executableHaskellDepends = [
    aeson base bytestring containers cookie exceptions hashable
    http-api-data http-media lens memory network-uri profunctors
    servant servant-auth servant-auth-swagger servant-swagger
    servant-swagger-ui-core string-conv swagger2 text time uuid
  ];
  testHaskellDepends = [
    aeson base bytestring containers exceptions hashable
    hercules-ci-api-core hspec http-api-data http-media protolude
    QuickCheck quickcheck-classes servant servant-auth string-conv text
    time uuid vector
  ];
  homepage = "https://github.com/hercules-ci/hercules-ci-agent#readme";
  description = "Hercules CI API definition with Servant";
  license = lib.licenses.asl20;
  mainProgram = "hercules-gen-swagger";
}
