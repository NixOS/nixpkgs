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
  version = "0.68.0";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-NGjys54VWzgy1SE93/zt8xooJhnZTst3jsjU36yp7Uk=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace "vendors/tezos-ligo/src/lib_hacl/hacl.ml" \
      --replace \
        "Hacl.NaCl.Noalloc.Easy.secretbox ~pt:msg ~n:nonce ~key ~ct:cmsg" \
        "Hacl.NaCl.Noalloc.Easy.secretbox ~pt:msg ~n:nonce ~key ~ct:cmsg ()" \
      --replace \
        "Hacl.NaCl.Noalloc.Easy.box_afternm ~pt:msg ~n:nonce ~ck:k ~ct:cmsg" \
        "Hacl.NaCl.Noalloc.Easy.box_afternm ~pt:msg ~n:nonce ~ck:k ~ct:cmsg ()"

    substituteInPlace "vendors/tezos-ligo/src/lib_crypto/crypto_box.ml" \
      --replace \
        "secretbox_open ~key ~nonce ~cmsg ~msg" \
        "secretbox_open ~key ~nonce ~cmsg ~msg ()" \
      --replace \
        "Box.box_open ~k ~nonce ~cmsg ~msg" \
        "Box.box_open ~k ~nonce ~cmsg ~msg ()"
  '';

  # The build picks this up for ligo --version
  LIGO_VERSION = version;

  # This is a hack to work around the hack used in the dune files
  OPAM_SWITCH_PREFIX = "${tezos-rust-libs}";

  duneVersion = "3";

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
