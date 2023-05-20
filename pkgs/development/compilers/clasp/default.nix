{ pkgs, lib, fetchFromGitHub, llvmPackages_15 }:


let

  src = fetchFromGitHub {
    owner = "clasp-developers";
    repo = "clasp";
    rev = "2.2.0";
    hash = "sha256-gvUqUb0dftW1miiBcAPJur0wOunox4y2SUYeeJpR9R4=";
  };

  reposDirs = [
    "dependencies"
    "src/lisp/kernel/contrib"
    "src/lisp/modules/asdf"
    "src/mps"
    "src/bdwgc"
    "src/libatomic_ops"
  ];

  reposTarball = llvmPackages_15.stdenv.mkDerivation {
    pname = "clasp-repos";
    version = "tarball";
    inherit src;
    patches = [ ./clasp-pin-repos-commits.patch ];
    nativeBuildInputs = with pkgs; [
      sbcl
      git
      cacert
    ];
    buildPhase = ''
      export SOURCE_DATE_EPOCH=1
      export ASDF_OUTPUT_TRANSLATIONS=$(pwd):$(pwd)/__fasls
      sbcl --script koga --help
      for x in {${lib.concatStringsSep "," reposDirs}}; do
        find $x -type d -name .git -exec rm -rvf {} \; || true
      done
    '';
    installPhase = ''
      tar --owner=0 --group=0 --numeric-owner --format=gnu \
        --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
        -czf $out ${lib.concatStringsSep " " reposDirs}
    '';
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = "sha256-vgwThjn2h3nKnShtKoHgaPdH/FDHv28fLMQvKFEwG6o=";
  };

in llvmPackages_15.stdenv.mkDerivation {
  pname = "clasp";
  version = "2.2.0";
  inherit src;
  nativeBuildInputs = (with pkgs; [
    sbcl
    git
    pkg-config
    fmt_9
    gmpxx
    libelf
    boost
    libunwind
    ninja
  ]) ++ (with llvmPackages_15; [
    llvm
    libclang
  ]);
  configurePhase = ''
  export SOURCE_DATE_EPOCH=1
  export ASDF_OUTPUT_TRANSLATIONS=$(pwd):$(pwd)/__fasls
  tar xf ${reposTarball}
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
  buildPhase = ''
  ninja -C build
'';
  installPhase = ''
  ninja -C build install
'';

  meta = {
    description = "A Common Lisp implementation based on LLVM with C++ integration";
    license = lib.licenses.lgpl21Plus ;
    maintainers = lib.teams.lisp.members;
    platforms = ["x86_64-linux" "x86_64-darwin"];
    # Upstream claims support, but breaks with:
    # error: use of undeclared identifier 'aligned_alloc'
    broken = llvmPackages_15.stdenv.isDarwin;
    homepage = "https://github.com/clasp-developers/clasp";
  };

}

