import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "1";
  sha256 = "18sycl3zmgb8ghpxymriy5d72gvw7m5ra65v51hcrmzzac21hkyd";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
