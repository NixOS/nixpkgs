{ stdenv
, fetchurl
, fetchFromGitHub
, makeWrapper
, mrustc
, mrustc-minicargo
, llvm_7
, libffi
, cmake
, python3
, zlib
, libxml2
, openssl
, pkgconfig
, curl
, which
, bash
}:

let
  mrustcVersion = "0.9";
  mrustcTag = "v${mrustcVersion}";
  rustcVersion = "1.29.0";
in

stdenv.mkDerivation {
  pname = "mrustc-bootstrap";
  version = "${mrustcVersion}_${rustcVersion}";

  src = fetchFromGitHub {
    owner = "thepowersgang";
    repo = "mrustc";
    rev = mrustcTag;
    sha256 = "194ny7vsks5ygiw7d8yxjmp1qwigd71ilchis6xjl6bb2sj97rd2";
  };
  rustcSrc = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${rustcVersion}-src.tar.gz";
    sha256 = "1sb15znckj8pc8q3g7cq03pijnida6cg64yqmgiayxkzskzk9sx4";
  };

  postUnpack = "tar -xf $rustcSrc -C source/";

  # the rust build system complains that nix alters the checksums
  dontFixLibtool = true;

  patches = [
    ./patches/0001-use-shared-mrustc-minicargo.patch
    ./patches/0002-use-shared-llvm.patch
    ./patches/0003-dont-build-llvm.patch
    ./patches/0004-echo-newlines.patch
    ./patches/0005-remove-time-dependency.patch
    ./patches/0006-settable-rust-target.patch
    ./patches/0007-increase-parallelism.patch
  ];

  postPatch = ''
    echo "applying patch ./rustc-${rustcVersion}-src.patch"
    patch -p0 -d rustc-${rustcVersion}-src/ < rustc-${rustcVersion}-src.patch
  '';

  # rustc unfortunately needs cmake to compile llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  buildInputs = [
    stdenv which bash makeWrapper
    # compiling toolchain
    mrustc mrustc-minicargo
    # for rustc
    llvm_7 libffi cmake python3 zlib libxml2
    # for cargo
    openssl pkgconfig curl cmake
  ];

  # Use shared mrustc/minicargo/llvm instead of rebuilding them
  MRUSTC = "${mrustc}/bin/mrustc";
  MINICARGO = "${mrustc-minicargo}/bin/minicargo";
  LLVM_CONFIG = "${llvm_7}/bin/llvm-config";

  RUSTC_TARGET = stdenv.buildPlatform.config;

  buildPhase = ''
    echo minicargo.mk: libs
    make -f minicargo.mk PARLEVEL=$NIX_BUILD_CORES LIBS

    echo minicargo.mk: deps
    mkdir -p output/cargo-build
    # minicargo has concurrency issues when running these; let's build them
    # without parallelism
    for crate in regex regex-0.2.11 curl-sys
    do
      echo "building $crate"
      minicargo rustc-${rustcVersion}-src/src/vendor/$crate --vendor-dir rustc-${rustcVersion}-src/src/vendor --output-dir output/cargo-build -L output/
    done

    echo minicargo.mk: rustc
    make -f minicargo.mk PARLEVEL=$NIX_BUILD_CORES output/rustc

    echo minicargo.mk: cargo
    make -f minicargo.mk PARLEVEL=$NIX_BUILD_CORES output/cargo

    echo run_rustc
    make -C run_rustc PARLEVEL=$NIX_BUILD_CORES
  '';

  doCheck = true;
  checkPhase = ''
    run_rustc/output/prefix/bin/hello_world | grep "hello, world"
  '';

  installPhase = ''
    mkdir -p $out/bin/ $out/lib/
    cp run_rustc/output/prefix/bin/cargo $out/bin/cargo
    cp run_rustc/output/prefix/bin/rustc_binary $out/bin/rustc

    cp -r run_rustc/output/prefix/lib/* $out/lib/
    cp $out/lib/rustlib/${stdenv.buildPlatform.config}/lib/*.so $out/lib/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/thepowersgang/mrustc";
    description = "A minimal build of Rust";
    longDescription = ''
      A minimal build of Rust, built from source using mrustc.
      This is useful for bootstrapping the main Rust compiler without
      an initial binary toolchain download.
    '';
    maintainers = with maintainers; [ progval ];
    license = with licenses; [ mit asl20 ];
    platforms = platforms.unix;
  };
}

