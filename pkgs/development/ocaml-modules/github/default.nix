{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
  cohttp,
  lwt,
  cohttp-lwt,
  github-data,
  yojson,
  stringext,
}:

buildDunePackage rec {
  pname = "github";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-github";
    rev = version;
    sha256 = "sha256-/IRoaGh4nYcdv4ir3LOS1d9UHLfWJ6DdPyFoFVCS+p4=";
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
