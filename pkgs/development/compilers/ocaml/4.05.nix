import ./generic.nix {
  major_version = "4";
  minor_version = "05";
  patch_version = "0";
  sha256 = "1y9fw1ci9pwnbbrr9nwr8cq8vypcxwdf4akvxard3mxl2jx2g984";

  # If the executable is stipped it does not work
  dontStrip = true;
}
