import ./generic.nix {
  major_version = "4";
  minor_version = "07";
  patch_version = "0+rc1";
  sha256 = "0ggzh078k68na2mahj3nrqkl57i1iv9aymlz8mmlcd8hbvp1fcn8";

  # If the executable is stripped it does not work
  dontStrip = true;
}
