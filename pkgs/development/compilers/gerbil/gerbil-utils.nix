<<<<<<< HEAD
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
=======
{ lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-utils";
  version = "unstable-2020-10-18";
  git-version = "0.2-36-g8b481b7";
  gerbil-package = "clan";
  gerbil = gerbil-unstable;
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-utils";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-utils";
    rev = "8b481b787e13e07e14d0718d670aab016131a090";
    sha256 = "0br8k5b2wcv4wcp65r2bfhji3af2qgqjspf41syqslq9awx47f3m";
  };
  meta = {
    description = "Gerbil Clan: Community curated Collection of Common Utilities";
    homepage    = "https://github.com/fare/gerbil-utils";
    license     = lib.licenses.lgpl21;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
