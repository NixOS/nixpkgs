{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.6";
  version = "${release}.12";

  # Note: when updating, the hash in pkgs/development/libraries/tk/8.6.nix must also be updated!

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "19n1wk6ypx19p26gywvibwbhqs2zapp93n3136qlhzhn1zfrbj96";
  };
})
