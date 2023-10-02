{ callPackage, zlib, libelf }:
callPackage ./common.nix rec {
  version = "20210528";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.gz";
  hash = "sha512-4PnIhVQFPubBsTM5YIkRieeCDEpN3DArfmN1Skzc/CrLG0tgg6ci0SBKdemU//NAHswlG4w7JAkPjLQEbZD4cA==";
  buildInputs = [ zlib libelf ];
  knownVulnerabilities = [ "CVE-2022-32200" "CVE-2022-39170" ];
}
