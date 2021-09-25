{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.3";
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
        hash = "sha256-gkF+l2RB7LPGE1AgiMm+LQSCiMKIntUjz0wcGXKpp4I=";
      };
}
