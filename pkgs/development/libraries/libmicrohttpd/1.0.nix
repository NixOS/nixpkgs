{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-qJ4J/JtN403eGfT8tPqqHOECmbmQjbETK7+h3keIK5Q=";
  };
})
