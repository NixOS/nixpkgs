{ fetchFromGitHub
, ...
}:

rec {
  version = "0.8.5";
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
        hash = "sha256-DX1xe3YC0PlhwbjsvbmUzNjrwhxFpbZW87WWbKcD0us=";
      };
}
