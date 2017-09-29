import ./generic.nix {
  major_version = "4";
  minor_version = "04";
  patch_version = "2";
  sha256 = "0bhgjzi78l10824qga85nlh18jg9lb6aiamf9dah1cs6jhzfsn6i";

  # If the executable is stipped it does not work
  dontStrip = true;
}
