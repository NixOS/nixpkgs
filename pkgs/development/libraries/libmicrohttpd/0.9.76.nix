{ callPackage, fetchurl }:

callPackage ./generic.nix ( rec {
  version = "0.9.76";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    sha256 = "sha256-8LFUe1pCpsD3JOjhwctc6cTDX7SV59eAuZMNNQEc60w=";
  };
})
