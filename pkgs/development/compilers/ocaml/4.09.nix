import ./generic.nix {
  major_version = "4";
  minor_version = "09";
  patch_version = "1";
  sha256 = "1aq5505lpa39garky2icgfv4c7ylpx3j623cz9bsz5c466d2kqls";

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
