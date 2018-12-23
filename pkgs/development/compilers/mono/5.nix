{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "5.16.0.220";
  sha256 = "1qwdmxssplfdb5rq86f1j8lskvr9dfk5c8hqz9ic09ml69r8c87l";
  enableParallelBuilding = false;
})
