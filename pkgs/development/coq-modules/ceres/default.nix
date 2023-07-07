{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {

  pname = "ceres";
  repo = "coq-ceres";
  owner = "Lysxia";

  inherit version;
  defaultVersion = if lib.versions.range "8.8" "8.16" coq.version then "0.4.0" else null;
  release."0.4.0".sha256 = "sha256:0zwp3pn6fdj0qdig734zdczrls886al06mxqhhabms0jvvqijmbi";

  meta = with lib; {
    description = "Library for serialization to S-expressions";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
