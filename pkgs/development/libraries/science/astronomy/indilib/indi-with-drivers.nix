{ buildEnv, makeBinaryWrapper, indilib ? indilib, pname ? "indi-with-drivers", version ? null, extraDrivers ? null }:

buildEnv {
  name = "${pname}-${version}";
  paths = [
    indilib
  ]
  ++ extraDrivers;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    makeBinaryWrapper ${indilib}/bin/indiserver $out/bin/indiserver --set-default INDIPREFIX $out
  '';


  inherit (indilib) meta;
}
