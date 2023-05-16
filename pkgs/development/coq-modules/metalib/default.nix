{ lib, mkCoqDerivation, coq, version ? null }:

<<<<<<< HEAD
(mkCoqDerivation {
=======
mkCoqDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "metalib";
  owner = "plclub";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
<<<<<<< HEAD
    { case = range "8.14" "8.18"; out = "8.15"; }
=======
    { case = range "8.14" "8.17"; out = "8.15"; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    { case = range "8.10" "8.13"; out = "8.10"; }
  ] null;
  releaseRev = v: "coq${v}";
  release."8.15".sha256 = "0wbp058zwa4bkdjj38aysy2g1avf9nrh8q23a3dil0q00qczi616";
  release."8.10".sha256 = "0wbypc05d2lqfm9qaw98ynr5yc1p0ipsvyc3bh1rk9nz7zwirmjs";

<<<<<<< HEAD
=======
  sourceRoot = "source/Metalib";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    license = licenses.mit;
    maintainers = [ maintainers.jwiegley ];
  };
<<<<<<< HEAD
}).overrideAttrs (oldAttrs: {
  sourceRoot = "${oldAttrs.src.name}/Metalib";
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
