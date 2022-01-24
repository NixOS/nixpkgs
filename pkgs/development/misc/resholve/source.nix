{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.9";
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
        hash = "sha256-y9O5w4wA/kR8zoPay9pGs3vwxNqq3JEeZmX0wBJq4UQ=";
      };
}
