{ lib
, fetchFromGitLab
, git
, coq
, ocamlPackages
, cacert
, ocaml-crunch
}:

ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "0.54.1";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-P4oScKsf2A6qtkzpep8lewqSMM9A+vHyN5VaH7+/6xQ=";
    fetchSubmodules = true;
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  duneVersion = "3";

  strictDeps = true;

  nativeBuildInputs = [
    ocaml-crunch
    git
    coq
    ocamlPackages.crunch
    ocamlPackages.menhir
    ocamlPackages.ocaml-recovery-parser
  ];

  buildInputs = with ocamlPackages; [
    coq
    menhir
    menhirLib
    qcheck
    ocamlgraph
    bisect_ppx
    decompress
    ppx_deriving
    ppx_deriving_yojson
    ppx_expect
    ppx_import
    terminal_size
    ocaml-recovery-parser
    yojson
    getopt
    core
    core_unix
    pprint
    linenoise
    crunch
    semver
    lambda-term
    tar-unix
    parse-argv

    # Test helpers deps
    qcheck
    qcheck-alcotest
    alcotest-lwt

    # vendored tezos' deps
    tezos-plonk
    tezos-bls12-381-polynomial
    ctypes
    ctypes_stubs_js
    class_group_vdf
    dune-configurator
    hacl-star
    hacl-star-raw
    lwt-canceler
    ipaddr
    bls12-381
    bls12-381-legacy
    bls12-381-signature
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
    ocamlPackages.ca-certs
  ];

  doCheck = false; # Tests fail, but could not determine the reason

  meta = with lib; {
    homepage = "https://ligolang.org/";
    downloadPage = "https://ligolang.org/docs/intro/installation";
    description = "A friendly Smart Contract Language for Tezos";
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
