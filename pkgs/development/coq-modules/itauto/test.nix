{
  stdenv,
  lib,
  coq,
  itauto,
}:

let
  excluded = lib.optionals (lib.versions.isEq "8.16" itauto.version) [
    "arith.v"
    "refl_bool.v"
  ];
in

stdenv.mkDerivation {
  pname = "coq${coq.coq-version}-itauto-test";
  inherit (itauto) src version;

  nativeCheckInputs = [
    coq
    itauto
  ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;

  checkPhase = ''
    cd test-suite
    for m in *.v
    do
      echo -n ${lib.concatStringsSep " " excluded} | grep --silent $m && continue
      echo $m && coqc $m
    done
  '';

  installPhase = "touch $out";
}
