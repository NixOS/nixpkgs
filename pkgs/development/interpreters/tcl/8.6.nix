{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.6";
  version = "${release}.4";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "13cwa4bc85ylf5gfj9vk182lvgy60qni3f7gbxghq78wk16djvly";
  };
})
