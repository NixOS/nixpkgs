import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "0+rc1";
  sha256 = "014yincnkfg0j2jy0cn30l5hb1y4sf2qf1gy9ix9ghgn32iw5ndk";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
