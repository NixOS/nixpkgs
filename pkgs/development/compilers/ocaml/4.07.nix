import ./generic.nix {
  major_version = "4";
  minor_version = "07";
  patch_version = "0+beta2";
  sha256 = "0rrvl47kq982z2ns7cnasmlbj60mpmza2zyhl1kh45c5a3n7692n";

  # If the executable is stripped it does not work
  dontStrip = true;
}
