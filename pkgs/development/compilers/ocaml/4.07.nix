import ./generic.nix {
  major_version = "4";
  minor_version = "07";
  patch_version = "0";
  sha256 = "03wzkzv6w4rdiiva20g5amz0n4x75swpjl8d80468p6zm8hgfnzl";

  # If the executable is stripped it does not work
  dontStrip = true;
}
