{ lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-utils";
  version = "unstable-2020-08-02";
  git-version = "0.2-21-g7e7d053";
  gerbil-package = "clan";
  gerbil = gerbil-unstable;
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-utils";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-utils";
    rev = "7e7d053ec5e78cc58d38cb03baf554d83b31b0c6";
    sha256 = "078vqdcddfavqq0d9pw430iz1562cgx1ck3fw6dpwxjkyc6m4bms";
  };
  meta = {
    description = "Gerbil Clan: Community curated Collection of Common Utilities";
    homepage    = "https://github.com/fare/gerbil-utils";
    license     = lib.licenses.lgpl21;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
