{ buildEnv, indilib ? indilib, pname ? "indi-with-drivers", version ? null, extraDrivers ? null }:

buildEnv {
  name = "${pname}-${version}";
  paths = [
    indilib
  ]
  ++ extraDrivers;
  inherit (indilib) meta;
}
