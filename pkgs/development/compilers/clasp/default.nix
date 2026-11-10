{
  lib,
  llvmPackages_22,
  fetchzip,
  ninja,
  sbcl,
  pkg-config,
  writableTmpDirAsHomeHook,
  boost,
  fmt,
  gmpxx,
  libelf,
}:

let
  inherit (llvmPackages_22)
    stdenv
    llvm
    libclang
    libunwind
    ;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "clasp";
  version = "3.0.1";

  src = fetchzip {
    url = "https://github.com/clasp-developers/clasp/releases/download/${finalAttrs.version}/clasp-${finalAttrs.version}.tar.gz";
    hash = "sha256-C6FwbLz/kjBcuI3225TczWaInkbQ3chtDhWCYh+a/2E=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./remove-unused-command-line-argument.patch
  ];

  # Workaround for https://github.com/clasp-developers/clasp/issues/1590
  postPatch = ''
    echo '(defmethod configure-unit (c (u (eql :git))))' >> src/koga/units.lisp
  '';

  nativeBuildInputs = [
    llvm.dev
    ninja
    pkg-config
    sbcl
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    boost
    fmt
    gmpxx
    libclang
    libelf
    libunwind
    llvm
  ];

  ninjaFlags = [
    "-C"
    "build"
  ];

  configurePhase = ''
    runHook preConfigure
    export SOURCE_DATE_EPOCH=1
    sbcl --script koga \
      --skip-sync \
      --cc=$NIX_CC/bin/cc \
      --cxx=$NIX_CC/bin/c++ \
      --jobs=$NIX_BUILD_CORES \
      --reproducible-build \
      --package-path=/ \
      --bin-path=$out/bin \
      --lib-path=$out/lib \
      --dylib-path=$out/lib \
      --share-path=$out/share \
      --pkgconfig-path=$out/lib/pkgconfig
    runHook postConfigure
  '';

  postInstall = ''
    # --dylib-path not honored. Fix it in post.
    mv $out/libclasp* $out/lib/
  '';

  meta = {
    description = "Common Lisp implementation based on LLVM with C++ integration";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.lisp ];
    platforms = [
      "x86_64-linux"
    ];
    homepage = "https://github.com/clasp-developers/clasp";
    mainProgram = "clasp";
  };
})
