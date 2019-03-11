import ./generic.nix {
  major_version = "4";
  minor_version = "08";
  patch_version = "0+beta1";
  sha256 = "1jgvp4pyhrg27wqpsx88kacw3ymjiz44nms9lzbh5s8pp05z5f5f";

  # If the executable is stripped it does not work
  dontStrip = true;

  # Breaks build with Clang
  hardeningDisable = [ "strictoverflow" ];
}
