{ callPackage, fetchurl }:

callPackage ./generic.nix ( rec {
  version = "0.9.70";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    sha256 = "01vkjy89b1ylmh22dy5yza2r414nfwcfixxh3v29nvzrjv9s7l4h";
  };
})
