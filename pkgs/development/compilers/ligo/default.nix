{ lib
, fetchFromGitLab
, git
, coq
, cacert
, ocaml-crunch
}:

coq.ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "0.47.0";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "0vaa4fbci5wdfkqvh68vyqg00s36h2sdajiahrbndxixl2j396sl";
    fetchSubmodules = true;
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  useDune2 = true;

  strictDeps = true;

  nativeBuildInputs = [
    ocaml-crunch
    git
    coq
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
    core_unix
    pprint
    linenoise
    dune-configurator
    ctypes_stubs_js
    crunch
    zarith_stubs_js
    pure-splitmix

    # Test helpers deps
    qcheck
    qcheck-alcotest
    alcotest-lwt

    # vendored tezos' deps
    ctypes
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
  ];

  checkInputs = [
    cacert
    coq.ocamlPackages.ca-certs
  ];

  doCheck = false; # Tests fail, but could not determine the reason

  patches = [ ./ligo.patch ];

  meta = with lib; {
    homepage = "https://ligolang.org/";
    downloadPage = "https://ligolang.org/docs/intro/installation";
    description = "A friendly Smart Contract Language for Tezos";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
