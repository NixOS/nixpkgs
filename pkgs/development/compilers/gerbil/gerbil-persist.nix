{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:
{
  pname = "gerbil-persist";
  version = "unstable-2020-08-31";
  git-version = "0.0-8-gd211390";
  gerbil-package = "clan/persist";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable; [gerbil-utils gerbil-crypto gerbil-poo];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-persist";
  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-persist";
    rev = "d211390c8a199cf2b8c7400cd98977524e960015";
    sha256 = "13s6ws8ziwalfp23nalss41qnz667z2712lr3y123sypm5n5axk7";
  };
  meta = {
    description = "Gerbil Persist: Persistent data and activities";
    homepage    = "https://github.com/fare/gerbil-persist";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
