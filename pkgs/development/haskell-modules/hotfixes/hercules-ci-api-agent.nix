{ mkDerivation, aeson, base, base64-bytestring-type, bytestring
, containers, cookie, deepseq, exceptions, hashable
, hercules-ci-api-core, hspec, http-api-data, http-media, lens
, lens-aeson, lib, memory, network-uri, profunctors, QuickCheck
, quickcheck-classes, servant, servant-auth, string-conv, swagger2
, text, time, unordered-containers, uuid, vector
}:
mkDerivation {
  pname = "hercules-ci-api-agent";
  version = "0.5.1.0";
  sha256 = "4d98e5a3824b09e3989251787dc0e3c9724011282eec343065c70ba9f1565ee6";
  libraryHaskellDepends = [
    aeson base base64-bytestring-type bytestring containers cookie
    deepseq exceptions hashable hercules-ci-api-core http-api-data
    http-media lens lens-aeson memory servant servant-auth string-conv
    swagger2 text time unordered-containers uuid vector
  ];
  testHaskellDepends = [
    aeson base bytestring containers cookie exceptions hashable
    hercules-ci-api-core hspec http-api-data http-media lens memory
    network-uri profunctors QuickCheck quickcheck-classes servant
    servant-auth string-conv swagger2 text time uuid vector
  ];
  homepage = "https://github.com/hercules-ci/hercules-ci-agent#readme";
  description = "API definition for Hercules CI Agent to talk to hercules-ci.com or Hercules CI Enterprise";
  license = lib.licenses.asl20;
}
