{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.8";
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
        hash = "sha256-1bb22GcOIzmQ31ULZuNNCJ8Vcz4Y0+qAhsJ9PhbqnDM=";
      };
}
