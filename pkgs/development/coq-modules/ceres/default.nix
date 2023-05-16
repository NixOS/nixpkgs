{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {

  pname = "ceres";
  repo = "coq-ceres";
  owner = "Lysxia";

  inherit version;
<<<<<<< HEAD
  defaultVersion = with lib.versions; lib.switch coq.version [
    { case = range "8.14" "8.18"; out = "0.4.1"; }
    { case = range "8.8"  "8.16"; out = "0.4.0"; }
  ] null;
  release."0.4.1".sha256 = "sha256-9vyk8/8IVsqNyhw3WPzl8w3L9Wu7gfaMVa3n2nWjFiA=";
  release."0.4.0".sha256 = "sha256:0zwp3pn6fdj0qdig734zdczrls886al06mxqhhabms0jvvqijmbi";

  useDuneifVersion = lib.versions.isGe "0.4.1";

=======
  defaultVersion = if lib.versions.range "8.8" "8.16" coq.version then "0.4.0" else null;
  release."0.4.0".sha256 = "sha256:0zwp3pn6fdj0qdig734zdczrls886al06mxqhhabms0jvvqijmbi";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Library for serialization to S-expressions";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
