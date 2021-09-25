{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.4";
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
        hash = "sha256-Wq9m67xkTs/8FA1XlwNuNXYSpseQdCa/GtgmsMSLtXI=";
      };
}
