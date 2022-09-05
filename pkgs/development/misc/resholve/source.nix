{ fetchFromGitHub
, ...
}:

rec {
  version = "0.8.1";
  rSrc =
    # local build -> `make ci`; `make clean` to restore
    # return to remote source
    # if builtins.pathExists ./.local
    # then ./.
    # else
      fetchFromGitHub {
        owner = "abathur";
        repo = "resholve";
        rev = "v${version}";
        hash = "sha256-EVrv4Lj9GQa3g18BRQjC0wCxzsfsn4Ka1iq5Ouu1cII=";
      };
}
