import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "0+beta3";
  sha256 = "02pk4bxrgqb12hvpbxyqnl4nwr4g2h96wsfzfd1k8vj8h0jmxzc4";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
