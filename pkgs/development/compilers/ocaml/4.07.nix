import ./generic.nix {
  major_version = "4";
  minor_version = "07";
  patch_version = "1";
  sha256 = "1f07hgj5k45cylj1q3k5mk8yi02cwzx849b1fwnwia8xlcfqpr6z";

  # If the executable is stripped it does not work
  dontStrip = true;
}
