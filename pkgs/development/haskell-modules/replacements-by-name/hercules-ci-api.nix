{ mkDerivation, aeson, base, bytestring, containers, cookie
, exceptions, hashable, hercules-ci-api-core, hspec, http-api-data
, http-media, insert-ordered-containers, lens, lens-aeson, lib
, memory, network-uri, openapi3, profunctors, protolude, QuickCheck
, quickcheck-classes, servant, servant-auth, servant-auth-swagger
, servant-openapi3, servant-swagger, servant-swagger-ui-core
, string-conv, swagger2, text, time, uuid, vector
}:
mkDerivation {
  pname = "hercules-ci-api";
  version = "0.8.4.0";
  sha256 = "6e7701d374ba9c3fc0491985f67e1d4a1ac477cc1eff6e37e1dcdc00e29a45dc";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring containers cookie exceptions hashable
    hercules-ci-api-core http-api-data http-media lens lens-aeson
    memory network-uri openapi3 profunctors servant servant-auth
    servant-auth-swagger servant-openapi3 servant-swagger
    servant-swagger-ui-core string-conv swagger2 text time uuid
  ];
  executableHaskellDepends = [
    aeson base bytestring containers cookie exceptions hashable
    http-api-data http-media insert-ordered-containers lens memory
    network-uri openapi3 profunctors servant servant-auth
    servant-auth-swagger servant-openapi3 servant-swagger
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
