{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.1";
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
        hash = "sha256-W7pZZBI3740zBSIpL+4MFuo9j5bkURdEjgv1EfKTFHQ=";
      };
}
