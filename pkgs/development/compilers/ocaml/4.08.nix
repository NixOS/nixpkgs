import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "0";
  sha256 = "0si976y8snbmhm96671di65z0rrdyldxd55wjxn2mkn6654nryna";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
