{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  lwt,
  ounit2,
}:

buildDunePackage rec {
  pname = "xenstore";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-xenstore";
    rev = "v${version}";
    hash = "sha256-LaynsbCE/+2QfbQCOLZi8nw1rqmZtgrwAov9cSxYZw8=";
  };

  propagatedBuildInputs = [ lwt ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = with lib; {
    description = "Xenstore protocol in pure OCaml";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      sternenseemann
      sigmasquadron
    ];
    homepage = "https://github.com/mirage/ocaml-xenstore";
  };
}
