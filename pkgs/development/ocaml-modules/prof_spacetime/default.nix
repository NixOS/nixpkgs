{ buildDunePackage
, lib
, fetchFromGitHub
, cmdliner
, spacetime_lib
, yojson
, cohttp
, ocaml_lwt
, cohttp-lwt-unix
, lambda-term
, stdlib-shims
}:

buildDunePackage rec {
  pname = "prof_spacetime";
  version = "0.3.0";
  useDune2 = true;

  src = fetchFromGitHub {
    owner = "lpw25";
    repo = pname;
    rev = version;
    sha256 = "1s88gf6x5almmyi58zx4q23w89mvahfjwhvyfg29ya5s1pjbc9hi";
  };

  buildInputs = [
    cmdliner
    spacetime_lib
    yojson
    cohttp
    ocaml_lwt
    cohttp-lwt-unix
    lambda-term
    stdlib-shims
  ];

  meta = {
    description = "A viewer for OCaml spacetime profiles";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.symphorien ];
    inherit (src.meta) homepage;
  };
}
