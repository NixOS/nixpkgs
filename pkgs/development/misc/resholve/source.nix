{ fetchFromGitHub
, ...
}:

rec {
  version = "0.8.4";
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
        hash = "sha256-K63d4Hs+q3N7A7TBQGgBYCNvZTMKTh89Q7PeFJMsU8o=";
      };
}
