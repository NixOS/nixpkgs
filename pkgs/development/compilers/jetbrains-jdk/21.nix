{
  callPackage,
  jetbrains,
  jdk,
  debugBuild ? false,
  withJcef ? true,
}:

callPackage ./common.nix
  {
    inherit jdk debugBuild withJcef;
  }
  {
    # To get the new tag:
    # git clone https://github.com/jetbrains/jetbrainsruntime
    # cd jetbrainsruntime
    # git tag --points-at [revision]
    # Look for the line that starts with jbr-
    javaVersion = "21.0.10";
    build = "1163.110";
    # run `git log -1 --pretty=%ct` in jdk repo for new value on update
    sourceDateEpoch = 1765114563;
    srcHash = "sha256-Qmffu7p6frBoH2Zh+EiqvEoMNNBE79qfkgLSC3+XuI0=";
    homePath = "${jetbrains.jdk-21}/lib/openjdk";
    jcefPackage = jetbrains.jcef-21;
  }
