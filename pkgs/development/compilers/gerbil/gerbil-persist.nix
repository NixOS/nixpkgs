{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-persist";
  version = "unstable-2020-08-02";
  git-version = "0.0-4-ga3b2bd1";
  gerbil-package = "clan/persist";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable; [gerbil-utils gerbil-crypto gerbil-poo];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-persist";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-persist";
    rev = "a3b2bd104612db0e4492737f09f72adea6684483";
    sha256 = "0mc01wva26ww1i7n8naa95mfw7i6lj8qg0bwsik7gb3dsj2acjvh";
  };
  meta = {
    description = "Gerbil Persist: Persistent data and activities";
    homepage    = "https://github.com/fare/gerbil-persist";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
