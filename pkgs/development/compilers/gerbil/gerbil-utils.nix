{ lib, fetchFromGitHub, ... }:

{
  pname = "gerbil-utils";
  version = "unstable-2023-10-08";
  git-version = "0.3-3-g2914428";
  softwareName = "Gerbil-utils";
  gerbil-package = "clan";
  version-path = "version";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-utils";
    rev = "29144289b40ce624adf30eab23b796ddd6b6b55d";
    sha256 = "0qysw2zs5acgri3wrjb3ngnnhd17xpr9hcdr4ya383k8k7jacr8a";
  };

  meta = with lib; {
    description = "Gerbil Clan: Community curated Collection of Common Utilities";
    homepage    = "https://github.com/fare/gerbil-utils";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
