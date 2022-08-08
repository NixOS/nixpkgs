{ qtModule
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtlottie";
  qtInputs = [ qtbase qtdeclarative ];
  meta = {
    # fix eval using release-lib.nix (lottie doesn't exist on qt512 that is used on darwin)
    badPlatforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
