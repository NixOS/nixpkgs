{ lib, buildDunePackage, fetchFromGitHub
, uri, cohttp, lwt, cohttp-lwt, github-data, yojson, stringext
}:

buildDunePackage rec {
  pname = "github";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-github";
    rev = version;
    sha256 = "sha256-psUIiIvjVV2NTlBtHnBisWreaKKnsqIjKT2+mLnfsxg=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [
    uri
    cohttp
    lwt
    cohttp-lwt
    github-data
    yojson
    stringext
  ];

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-github";
    description = "GitHub APIv3 OCaml library";
    license = licenses.mit;
    maintainers = with maintainers; [ niols ];
  };
}
