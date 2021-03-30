{ buildEnv, indilib ? indilib, extraDrivers ? null , pkgName ? "indi-with-drivers" }:

buildEnv {
  name = pkgName;
  paths = [
    indilib
  ]
  ++ extraDrivers;
}
