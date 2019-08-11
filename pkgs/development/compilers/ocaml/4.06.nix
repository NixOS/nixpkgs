import ./generic.nix {
  major_version = "4";
  minor_version = "06";
  patch_version = "1";
  sha256 = "1n3pygfssd6nkrq876wszm5nm3v4605q4k16a66h1nmq9wvf01vg";

  # If the executable is stipped it does not work
  dontStrip = true;
}
