{ fetchFromGitHub
, ...
}:

rec {
  version = "0.8.3";
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
        hash = "sha256-HilYaHSMASYXNGoX9/QSP9mpspszksdUrxlkUB1yGHQ=";
      };
}
