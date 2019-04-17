import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "0+beta2";
  sha256 = "1ngsrw74f3hahzsglxkrdxzv86bkmpsiaaynnzjwfwyzvy8sqrac";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
