{ lib
, fetchFromGitLab
, git
, coq
, cacert
}:

coq.ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "0.43.0";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-HnfVrfypav9UxXJ9cuD1DF7vUFUiAc4nkApoLIgLsWA=";
    fetchSubmodules = true;
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  strictDeps = true;

  nativeBuildInputs = [
    git
    coq
    coq.ocamlPackages.crunch
    coq.ocamlPackages.menhir
    coq.ocamlPackages.ocaml-recovery-parser
  ];

  buildInputs = with coq.ocamlPackages; [
    coq
    menhir
    menhirLib
    qcheck
    ocamlgraph
    bisect_ppx
    ppx_deriving
    ppx_deriving_yojson
    ppx_expect
    ppx_import
    terminal_size
    ocaml-recovery-parser
    yojson
    getopt
    core
    crunch
    pprint
    linenoise

    # Test helpers deps
    qcheck
    qcheck-alcotest
    alcotest-lwt

    # vendored tezos' deps
    ctypes
    ctypes_stubs_js
    dune-configurator
    hacl-star
    hacl-star-raw
    lwt-canceler
    ipaddr
    bls12-381
    bls12-381-legacy
    ptime
    mtime
    lwt_log
    ringo
    ringo-lwt
    secp256k1-internal
    resto
    resto-directory
    resto-cohttp-self-serving-client
    irmin-pack
    ezjsonm
    data-encoding
    pure-splitmix
    zarith_stubs_js
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
    platforms = coq.ocaml.meta.platforms;
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
