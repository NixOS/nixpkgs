import ./generic.nix {
  major_version = "4";
  minor_version = "06";
  patch_version = "0";
  sha256 = "1dy542yfnnw10zvh5s9qzswliq11mg7l0bcyss3501qw3vwvadhj";

  # If the executable is stipped it does not work
  dontStrip = true;
}
