import ./generic.nix {
  major_version = "4";
  minor_version = "04";
  patch_version = "1";
  sha256 = "11f2kcldpad9h5ihi1crad5lvv2501iccb2g4c8m197fnjac8b12";

  # If the executable is stipped it does not work
  dontStrip = true;
}
