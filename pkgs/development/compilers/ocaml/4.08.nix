import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "0+rc2";
  sha256 = "09wp2iig6v5pivkjcnibdvkg5mchcj3q4zms6ij67039xczm8qrg";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
