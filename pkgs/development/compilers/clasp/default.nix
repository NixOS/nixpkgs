{ lib
, llvmPackages_15
, fetchFromGitHub
, sbcl
, git
, pkg-config
, fmt_9
, gmpxx
, libelf
, boost
, libunwind
, ninja
, cacert
}:

let
  inherit (llvmPackages_15) stdenv llvm libclang;

  # Gathered from https://github.com/clasp-developers/clasp/raw/2.2.0/repos.sexp
  dependencies = import ./dependencies.nix {
    inherit fetchFromGitHub;
  };

  # Shortened version of `_defaultUnpack`
  unpackDependency = elem: ''
    mkdir -p "source/${elem.directory}"
    cp -pr --reflink=auto -- ${elem.src}/* "source/${elem.directory}"
    chmod -R u+w -- "source/${elem.directory}"
  '';
in

stdenv.mkDerivation {
  pname = "clasp";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "clasp-developers";
    repo = "clasp";
    rev = "2.2.0";
    hash = "sha256-gvUqUb0dftW1miiBcAPJur0wOunox4y2SUYeeJpR9R4=";
  };

  patches = [
    ./clasp-pin-repos-commits.patch
    ./remove-unused-command-line-argument.patch
  ];

  nativeBuildInputs = [
    sbcl
    git
    pkg-config
    fmt_9
    gmpxx
    libelf
    boost
    libunwind
    ninja
    llvm
    libclang
  ];

  ninjaFlags = [ "-C" "build" ];

  postUnpack = lib.concatStringsSep "\n" (builtins.map unpackDependency dependencies);

  configurePhase = ''
    export SOURCE_DATE_EPOCH=1
    export ASDF_OUTPUT_TRANSLATIONS=$(pwd):$(pwd)/__fasls
    sbcl --script koga \
      --skip-sync \
      --cc=$NIX_CC/bin/cc \
      --cxx=$NIX_CC/bin/c++ \
      --reproducible-build \
      --package-path=/ \
      --bin-path=$out/bin \
      --lib-path=$out/lib \
      --share-path=$out/share
  '';

  meta = {
    description = "A Common Lisp implementation based on LLVM with C++ integration";
    license = lib.licenses.lgpl21Plus ;
    maintainers = lib.teams.lisp.members;
    platforms = ["x86_64-linux" "x86_64-darwin"];
    # Upstream claims support, but breaks with:
    # error: use of undeclared identifier 'aligned_alloc'
    broken = stdenv.isDarwin;
    homepage = "https://github.com/clasp-developers/clasp";
  };
}
