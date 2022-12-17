{ lib, buildDunePackage, fetchFromGitHub
, lwt_ppx, lwt
}:

buildDunePackage rec {
  pname = "ocsipersist-lib";
  version = "1.1.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsipersist";
    rev = version;
    sha256 = "sha256:1d6kdcfjvrz0dl764mnyxc477aa57rvmzkg154qc915w2y1nbz9a";
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
