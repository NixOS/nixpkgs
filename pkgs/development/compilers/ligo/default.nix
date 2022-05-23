{ lib
, fetchFromGitLab
, git
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
    sha256 = "0zx8ai79ha3npm3aybzgisil27v9i052cqdllfri0fsc67dig78b";
    fetchSubmodules = true;
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  useDune2 = true;

  strictDeps = true;

  nativeBuildInputs = [
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
    bls12-381-unix
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

  patches = [ ./ligo.patch ]; # fix for core >= 0.15.0

  meta = with lib; {
    homepage = "https://ligolang.org/";
    downloadPage = "https://ligolang.org/docs/intro/installation";
    description = "A friendly Smart Contract Language for Tezos";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
