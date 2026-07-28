{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-tG0A9Y76b0l7l9LngsTuZjAdQS3dhV3TBoUYs6LNPqI=";
  };
}
