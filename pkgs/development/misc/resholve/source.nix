{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.5";
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
        hash = "sha256-4fTACLDsHxVGYMOm08wQs4gFWMu8kv0O12IyOZSROqw=";
      };
}
