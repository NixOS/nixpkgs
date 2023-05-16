{ lib, mkCoqDerivation, coq, version ? null
, ssreflect
}:

mkCoqDerivation {
  pname = "deriving";
  owner = "arthuraa";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
<<<<<<< HEAD
    { case = range "8.11" "8.18"; out = "0.1.1"; }
=======
    { case = range "8.11" "8.16"; out = "0.1.0"; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] null;

  releaseRev = v: "v${v}";

<<<<<<< HEAD
  release."0.1.1".sha256 = "sha256-Gu8aInLxTXfAFE0/gWRYI046Dx3Gv1j1+gx92v/UnPI=";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  release."0.1.0".sha256 = "sha256:11crnjm8hyis1qllkks3d7r07s1rfzwvyvpijya3s6iqfh8c7xwh";

  propagatedBuildInputs = [ ssreflect ];

  mlPlugin = true;

  meta = with lib; {
    description = "Generic instances of MathComp classes";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}
