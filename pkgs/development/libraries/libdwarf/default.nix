{ callPackage, zlib, libelf }:
callPackage ./common.nix rec {
  version = "20210528";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.gz";
  sha512 = "e0f9c88554053ee6c1b1333960891189e7820c4a4ddc302b7e63754a4cdcfc2acb1b4b6083a722d1204a75e994fff3401ecc251b8c3b24090f8cb4046d90f870";
  buildInputs = [ zlib libelf ];
  knownVulnerabilities = [ "CVE-2022-32200" ];
}
