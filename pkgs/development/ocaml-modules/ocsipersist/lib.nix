{ lib, buildDunePackage, fetchFromGitHub
, lwt_ppx, lwt
}:

buildDunePackage rec {
  pname = "ocsipersist-lib";
  version = "2.0.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsipersist";
    rev = version;
    sha256 = "sha256-7CKKwJxqxUpCMNs4xGbsMZ6Qud9AnczBStTXS+N21DU=";
  };

  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [ lwt ];

  meta = {
    description = "Persistent key/value storage (for Ocsigen) - support library";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
