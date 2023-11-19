{ fetchFromGitHub
, ...
}:

rec {
  version = "0.9.0";
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
        hash = "sha256-FRdCeeC2c3bMEXekEyilgW0PwFfUWGstZ5mXdmRPM5w=";
      };
}
