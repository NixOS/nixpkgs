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
}:

ocamlPackages.buildDunePackage rec {
  pname = "ligo";
  version = "0.63.2";
  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = version;
    sha256 = "sha256-VR8ceCRiSaOteVkd6WfTzzYnpeBbCfDltSknx8mwuS4=";
    fetchSubmodules = true;
  };

  # The build picks this up for ligo --version
  LIGO_VERSION = version;
  CHANGELOG_PATH = "./changelog.txt";

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
    simple-diff
  ];

  nativeCheckInputs = [
    cacert
    ocamlPackages.ca-certs
  ];

  preBuild = ''
    # The scripts use `nix-shell` in the shebang which seems to fail
    sed -i -e '1,5d' ./scripts/changelog-generation.sh
    sed -i -e '1,5d' ./scripts/changelog-json.sh
    ./scripts/changelog-generation.sh
  '';

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
