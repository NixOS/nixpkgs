{ lib
, llvmPackages_15
, fetchzip
, sbcl
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
in

stdenv.mkDerivation rec {
  pname = "clasp";
  version = "2.6.0";

  src = fetchzip {
    url = "https://github.com/clasp-developers/clasp/releases/download/${version}/clasp-${version}.tar.gz";
    hash = "sha256-SiQ4RMha6dMV7V2fh+UxtAIgEEH/6/hF9fe+bPtoGIw=";
  };

  patches = [
    ./remove-unused-command-line-argument.patch
  ];

  # Workaround for https://github.com/clasp-developers/clasp/issues/1590
  postPatch = ''
    echo '(defmethod configure-unit (c (u (eql :git))))' >> src/koga/units.lisp
  '';

  nativeBuildInputs = [
    sbcl
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

  configurePhase = ''
    export SOURCE_DATE_EPOCH=1
    export ASDF_OUTPUT_TRANSLATIONS=$(pwd):$(pwd)/__fasls
    sbcl --script koga \
      --skip-sync \
      --build-mode=bytecode-faso \
      --cc=$NIX_CC/bin/cc \
      --cxx=$NIX_CC/bin/c++ \
      --reproducible-build \
      --package-path=/ \
      --bin-path=$out/bin \
      --lib-path=$out/lib \
      --share-path=$out/share
  '';

  meta = {
    description = "Common Lisp implementation based on LLVM with C++ integration";
    license = lib.licenses.lgpl21Plus ;
    maintainers = lib.teams.lisp.members;
    platforms = ["x86_64-linux" "x86_64-darwin"];
    # Upstream claims support, but breaks with:
    # error: use of undeclared identifier 'aligned_alloc'
    broken = stdenv.isDarwin;
    homepage = "https://github.com/clasp-developers/clasp";
    mainProgram = "clasp";
  };
}
