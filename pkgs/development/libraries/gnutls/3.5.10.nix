{ callPackage, fetchurl, libunistring, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.10";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "17apwvdkkazh5w8z8mbanpj2yj8s2002qwy46wz4v3akpa33wi5g";
  };
})
