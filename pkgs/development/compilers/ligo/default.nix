{ stdenv
, lib
, fetchFromGitLab
, git
, coq
, ocamlPackages
, cacert
, ocaml-crunch
, jq
, mustache-go
, yaml2json
, tezos-rust-libs
, darwin
}:

ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "1.0.0";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-tHIIA1JE7mzDIf2v9IEZt1pjVQEA89zjTsmqhzTn3Wc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace "vendors/tezos-ligo/dune-project" \
      --replace \
        "(using ctypes 0.1)" \
        "(using ctypes 0.3)" \
      --replace \
        "(lang dune 3.0)" \
        "(lang dune 3.7)"

    substituteInPlace "src/coq/dune" \
      --replace \
        "(name ligo_coq)" \
        "(name ligo_coq)(mode vo)"
  '';

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  # This is a hack to work around the hack used in the dune files
  OPAM_SWITCH_PREFIX = "${tezos-rust-libs}";

  strictDeps = true;

  nativeBuildInputs = [
    ocaml-crunch
    git
    coq
    ocamlPackages.crunch
    ocamlPackages.menhir
    ocamlPackages.ocaml-recovery-parser
    # deps for changelog
    jq
    mustache-go
    yaml2json
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
    ppx_yojson_conv
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
    hacl-star
    prometheus
    lwt_ppx
    msgpck
    # lsp
    linol
    linol-lwt
    ocaml-lsp
    # Test helpers deps
    qcheck
    qcheck-alcotest
    alcotest-lwt
    # vendored tezos' deps
    aches
    aches-lwt
    ctypes
    ctypes_stubs_js
    class_group_vdf
    dune-configurator
    hacl-star
    hacl-star-raw
    lwt-canceler
    ipaddr
    bls12-381
    bls12-381-signature
    ptime
    mtime_1
    lwt_log
    secp256k1-internal
    resto
    resto-directory
    resto-cohttp-self-serving-client
    irmin-pack
    ezjsonm
    data-encoding
    pure-splitmix
    zarith_stubs_js
    simple-diff
    seqes
    stdint
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
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
    broken = stdenv.isLinux && stdenv.isAarch64;
    maintainers = with maintainers; [ ulrikstrid ];
  };
}
