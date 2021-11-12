{ fetchFromGitHub
, ...
}:

rec {
  version = "0.6.7";
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
        hash = "sha256-UDY8E9XWtNIG/4ovZcSR5iWKD19NVaWIwmnI0JROCYs=";
      };
}
