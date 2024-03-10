{ mkDerivation, aeson, base, base64-bytestring-type, bytestring
, containers, cookie, deepseq, exceptions, hashable
, hercules-ci-api-core, hspec, http-api-data, http-media, lens
, lens-aeson, lib, memory, network-uri, profunctors, QuickCheck
, quickcheck-classes, servant, servant-auth, string-conv, swagger2
, text, time, unordered-containers, uuid, vector
}:
mkDerivation {
  pname = "hercules-ci-api-agent";
  version = "0.5.0.1";
  sha256 = "4f839cc0d03a65a507092081a21280afba64c8f558f13ae96f90f8aa82ab2c35";
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
