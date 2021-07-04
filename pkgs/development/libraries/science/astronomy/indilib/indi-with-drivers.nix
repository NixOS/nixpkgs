{ buildEnv, indilib, pname ? "indi-with-drivers", version, extraDrivers }:

buildEnv {
  name = "${pname}-${version}";
  paths = [
    indilib
  ]
  ++ extraDrivers;
  inherit (indilib) meta;
}
