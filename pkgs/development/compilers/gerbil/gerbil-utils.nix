{ lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-utils";
  version = "unstable-2020-05-17";
  git-version = "33ef720";
  package = "clan";
  gerbil = gerbil-unstable;
  gambit-params = gambit-support.unstable-params;
  version-path = "";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-utils";
    rev = "33ef720799ba98dc9eec773c662f070af4bac016";
    sha256 = "0dsb97magbxzjqqfzwq4qwf7i80llv0s1dsy9nkzkvkq8drxlmqf";
  };
  meta = {
    description = "Gerbil Clan: Community curated Collection of Common Utilities";
    homepage    = "https://github.com/fare/gerbil-utils";
    license     = lib.licenses.lgpl21;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
