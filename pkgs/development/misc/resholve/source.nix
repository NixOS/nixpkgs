{ fetchFromGitHub
, ...
}:

rec {
  version = "0.8.0";
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
        hash = "sha256-oWS4ZBPjgH2UvYmvHVVRcyl15r3VS964BmB89y9DGo8=";
      };
}
