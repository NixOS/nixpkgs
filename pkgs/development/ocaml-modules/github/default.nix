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
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-github";
    rev = version;
    sha256 = "sha256-nxHXOdZAvFe5/lKNw7tTJmY86xzfdFT+fW+lnKioyPM=";
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

  meta = {
    homepage = "https://github.com/mirage/ocaml-github";
    description = "GitHub APIv3 OCaml library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ niols ];
  };
}
