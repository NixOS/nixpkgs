{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.10.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-sPzdf8DN6m6A3PHdhbp5SvDVtKV+Jjl+7jvBkyctkTI=";
  };
}
