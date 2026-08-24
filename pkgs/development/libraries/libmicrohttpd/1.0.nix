{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-u1z8rfxS29XrUS1uKZXgNhNRwz6XqHq6Qm06Snumz3A=";
  };
}
