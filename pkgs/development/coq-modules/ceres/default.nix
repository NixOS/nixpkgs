{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

mkCoqDerivation {

  pname = "ceres";
  repo = "coq-ceres";
  owner = "Lysxia";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.14" "8.20";
        out = "0.4.1";
      }
      {
        case = range "8.8" "8.16";
        out = "0.4.0";
      }
    ] null;
  release."0.4.1".sha256 = "sha256-9vyk8/8IVsqNyhw3WPzl8w3L9Wu7gfaMVa3n2nWjFiA=";
  release."0.4.0".sha256 = "sha256:0zwp3pn6fdj0qdig734zdczrls886al06mxqhhabms0jvvqijmbi";

  useDuneifVersion = lib.versions.isGe "0.4.1";

  propagatedBuildInputs = [ stdlib ];

  meta = with lib; {
    description = "Library for serialization to S-expressions";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
