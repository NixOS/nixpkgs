{ lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:
{
  pname = "gerbil-utils";
  version = "unstable-2020-10-18";
  git-version = "0.2-36-g8b481b7";
  gerbil-package = "clan";
  gerbil = gerbil-unstable;
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-utils";
  pre-src = {
    fun = fetchFromGitHub;
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
  };
}
