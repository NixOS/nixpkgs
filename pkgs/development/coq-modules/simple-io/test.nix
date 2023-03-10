{ stdenv, coq, simple-io }:

stdenv.mkDerivation {
  pname = "coq-simple-io-test";
  inherit (simple-io) src version;
  nativeCheckInputs = [ coq simple-io ];
  dontConfigure = true;
  dontBuild = true;
  doCheck = true;

  checkPhase = ''
    cd test
    for p in Argv.v Example.v HelloWorld.v TestExtraction.v TestPervasives.v
    do
      [ -f $p ] && echo $p && coqc $p
    done
  '';

  installPhase = "touch $out";

}
