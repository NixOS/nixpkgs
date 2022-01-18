{ lib
, fetchFromGitLab
, coq
, cacert
}:

coq.ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "0.27.0";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-OUrjMlAWxTPs56ltMt0I/XR9GScD6upXU2arT99u8hk=";
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  useDune2 = true;

  buildInputs = with coq.ocamlPackages; [
    coq
    menhir
    menhirLib
    qcheck
    ocamlgraph
    ppx_deriving
    ppx_deriving_yojson
    ppx_expect
    tezos-base
    tezos-shell-services
    tezos-010-PtGRANAD-test-helpers
    tezos-protocol-010-PtGRANAD-parameters
    tezos-protocol-010-PtGRANAD
    tezos-protocol-environment
    yojson
    getopt
    terminal_size
    pprint
    linenoise
    data-encoding
    bisect_ppx
    cmdliner
  ];

  checkInputs = [
    cacert
    coq.ocamlPackages.ca-certs
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://ligolang.org/";
    downloadPage = "https://ligolang.org/docs/intro/installation";
    description = "A friendly Smart Contract Language for Tezos";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
