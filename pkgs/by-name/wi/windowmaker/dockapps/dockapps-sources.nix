{ fetchFromRepoOrCz }:

# We are interested in the pristine sources; installation phases are not needed
# here
fetchFromRepoOrCz {
  pname = "dockapps-sources";
  version = "0-unstable-2023-10-11"; # Shall correspond to rev below
  repo = "dockapps";
  rev = "1bbb32008ecb58acaec9ea70e00b4ea1735408fc";
  hash = "sha256-BLUDe/cIIuh9mCtafbcBSDatUXSRD83FeyYhcbem5FU=";
}
# TODO: update script
