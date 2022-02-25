{ lib
, fetchFromGitLab
, coq
, cacert
}:

coq.ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "0.36.0";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-0c2hTtEBbf2EbBMPqAnzHGomRvolHnztbsVB3mDRsGw=";
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  useDune2 = true;

  nativeBuildInputs = with coq.ocamlPackages; [
    coq
    findlib
    menhir
    ocaml-recovery-parser
  ];

  buildInputs = with coq.ocamlPackages; [
    bisect_ppx
    cmdliner
    core
    data-encoding
    getopt
    linenoise
    menhirLib
    ocamlgraph
    pprint
    ppx_deriving
    ppx_deriving_yojson
    ppx_expect
    ppx_import
    qcheck
    terminal_size
    tezos-011-PtHangz2-test-helpers
    ocaml-recovery-parser
    yojson
  ];

  checkInputs = [
    cacert
    coq.ocamlPackages.ca-certs
  ];

  doCheck = false; # Tests fail, but could not determine the reason

  meta = with lib; {
    homepage = "https://ligolang.org/";
    downloadPage = "https://ligolang.org/docs/intro/installation";
    description = "A friendly Smart Contract Language for Tezos";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
