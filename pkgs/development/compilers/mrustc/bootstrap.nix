{ lib, stdenv
, fetchurl
, mrustc
, mrustc-minicargo
, rust
, llvm_7
, llvmPackages_7
, libffi
, cmake
, python3
, zlib
, libxml2
, openssl
, pkg-config
, curl
, which
, time
}:

let
  rustcVersion = "1.29.0";
  rustcSrc = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${rustcVersion}-src.tar.gz";
    sha256 = "1sb15znckj8pc8q3g7cq03pijnida6cg64yqmgiayxkzskzk9sx4";
  };
  rustcDir = "rustc-${rustcVersion}-src";
in

stdenv.mkDerivation rec {
  pname = "mrustc-bootstrap";
  version = "${mrustc.version}_${rustcVersion}";

  inherit (mrustc) src;
  postUnpack = "tar -xf ${rustcSrc} -C source/";

  # the rust build system complains that nix alters the checksums
  dontFixLibtool = true;

  patches = [
    ./patches/0001-use-shared-llvm.patch
    ./patches/0002-dont-build-llvm.patch
    ./patches/0003-echo-newlines.patch
    ./patches/0004-increase-parallelism.patch
  ];

  postPatch = ''
    echo "applying patch ./rustc-${rustcVersion}-src.patch"
    patch -p0 -d ${rustcDir}/ < rustc-${rustcVersion}-src.patch

    for p in ${lib.concatStringsSep " " llvmPackages_7.compiler-rt.patches}; do
      echo "applying patch $p"
      patch -p1 -d ${rustcDir}/src/libcompiler_builtins/compiler-rt < $p
    done
  '';

  # rustc unfortunately needs cmake to compile llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    mrustc
    mrustc-minicargo
    pkg-config
    python3
    time
    which
  ];
  buildInputs = [
    # for rustc
    llvm_7 libffi zlib libxml2
    # for cargo
    openssl curl
  ];

  makeFlags = [
    # Use shared mrustc/minicargo/llvm instead of rebuilding them
    "MRUSTC=${mrustc}/bin/mrustc"
    "MINICARGO=${mrustc-minicargo}/bin/minicargo"
    "LLVM_CONFIG=${llvm_7.dev}/bin/llvm-config"
    "RUSTC_TARGET=${rust.toRustTarget stdenv.targetPlatform}"
  ];

  buildPhase = ''
    runHook preBuild

    local flagsArray=(
      PARLEVEL=$NIX_BUILD_CORES
      ${toString makeFlags}
    )

    echo minicargo.mk: libs
    make -f minicargo.mk "''${flagsArray[@]}" LIBS

    echo minicargo.mk: deps
    mkdir -p output/cargo-build
    # minicargo has concurrency issues when running these; let's build them
    # without parallelism
    for crate in regex regex-0.2.11 curl-sys
    do
      echo "building $crate"
      minicargo ${rustcDir}/src/vendor/$crate \
        --vendor-dir ${rustcDir}/src/vendor \
        --output-dir output/cargo-build -L output/
    done

    echo minicargo.mk: rustc
    make -f minicargo.mk "''${flagsArray[@]}" output/rustc

    echo minicargo.mk: cargo
    make -f minicargo.mk "''${flagsArray[@]}" output/cargo

    echo run_rustc
    make -C run_rustc "''${flagsArray[@]}"

    unset flagsArray

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    run_rustc/output/prefix/bin/hello_world | grep "hello, world"
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/ $out/lib/
    cp run_rustc/output/prefix/bin/cargo $out/bin/cargo
    cp run_rustc/output/prefix/bin/rustc_binary $out/bin/rustc

    cp -r run_rustc/output/prefix/lib/* $out/lib/
    cp $out/lib/rustlib/${rust.toRustTarget stdenv.targetPlatform}/lib/*.so $out/lib/
    runHook postInstall
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A minimal build of Rust";
    longDescription = ''
      A minimal build of Rust, built from source using mrustc.
      This is useful for bootstrapping the main Rust compiler without
      an initial binary toolchain download.
    '';
    maintainers = with maintainers; [ progval r-burns ];
    license = with licenses; [ mit asl20 ];
    platforms = [ "x86_64-linux" ];
  };
}

