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
<<<<<<< HEAD
    for p in Argv.v Example.v HelloWorld.v TestExtraction.v TestOcamlbuild.v TestPervasives.v
=======
    for p in Argv.v Example.v HelloWorld.v TestExtraction.v TestPervasives.v
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    do
      [ -f $p ] && echo $p && coqc $p
    done
  '';

  installPhase = "touch $out";

}
