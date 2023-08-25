{ lib, fetchFromGitHub, ... }:

{
  pname = "gerbil-utils";
  version = "unstable-2023-07-22";
  git-version = "0.2-198-g2fb01ce";
  softwareName = "Gerbil-utils";
  gerbil-package = "clan";
  version-path = "version";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-utils";
    rev = "2fb01ce0b302f232f5c4daf4987457b6357d609d";
    sha256 = "127q98gk1x6y1nlkkpnbnkz989ybpszy7aiy43hzai2q6xn4nv72";
  };

  meta = with lib; {
    description = "Gerbil Clan: Community curated Collection of Common Utilities";
    homepage    = "https://github.com/fare/gerbil-utils";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
