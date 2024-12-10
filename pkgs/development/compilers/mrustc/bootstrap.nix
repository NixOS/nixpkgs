{
  lib,
  stdenv,
  fetchurl,
  mrustc,
  mrustc-minicargo,
  llvm_12,
  libffi,
  cmake,
  python3,
  zlib,
  libxml2,
  openssl,
  pkg-config,
  curl,
  which,
  time,
}:

let
  mrustcTargetVersion = "1.54";
  rustcVersion = "1.54.0";
  rustcSrc = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${rustcVersion}-src.tar.gz";
    sha256 = "0xk9dhfff16caambmwij67zgshd8v9djw6ha0fnnanlv7rii31dc";
  };
  rustcDir = "rustc-${rustcVersion}-src";
  outputDir = "output-${rustcVersion}";
in

stdenv.mkDerivation rec {
  pname = "mrustc-bootstrap";
  version = "${mrustc.version}_${rustcVersion}";

  inherit (mrustc) src;
  postUnpack = "tar -xf ${rustcSrc} -C source/";

  # the rust build system complains that nix alters the checksums
  dontFixLibtool = true;

  patches = [
    ./patches/0001-dont-download-rustc.patch
  ];

  postPatch = ''
    echo "applying patch ./rustc-${rustcVersion}-src.patch"
    patch -p0 -d ${rustcDir}/ < rustc-${rustcVersion}-src.patch
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
    llvm_12
    libffi
    zlib
    libxml2
    # for cargo
    openssl
    (curl.override { inherit openssl; })
  ];

  makeFlags = [
    # Use shared mrustc/minicargo/llvm instead of rebuilding them
    "MRUSTC=${mrustc}/bin/mrustc"
    #"MINICARGO=${mrustc-minicargo}/bin/minicargo"  # FIXME: we need to rebuild minicargo locally so --manifest-overrides is applied
    "LLVM_CONFIG=${llvm_12.dev}/bin/llvm-config"
    "RUSTC_TARGET=${stdenv.targetPlatform.rust.rustcTarget}"
  ];

  buildPhase = ''
    runHook preBuild

    local flagsArray=(
      PARLEVEL=$NIX_BUILD_CORES
      ${toString makeFlags}
    )

    touch ${rustcDir}/dl-version
    export OUTDIR_SUF=-${rustcVersion}
    export RUSTC_VERSION=${rustcVersion}
    export MRUSTC_TARGET_VER=${mrustcTargetVersion}
    export MRUSTC_PATH=${mrustc}/bin/mrustc

    echo minicargo.mk: libs
    make -f minicargo.mk "''${flagsArray[@]}" LIBS

    echo test
    make "''${flagsArray[@]}" test

    # disabled because it expects ./bin/mrustc
    #echo local_tests
    #make "''${flagsArray[@]}" local_tests

    echo minicargo.mk: rustc
    make -f minicargo.mk "''${flagsArray[@]}" ${outputDir}/rustc

    echo minicargo.mk: cargo
    make -f minicargo.mk "''${flagsArray[@]}" ${outputDir}/cargo

    echo run_rustc
    make -C run_rustc "''${flagsArray[@]}"

    unset flagsArray

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    run_rustc/${outputDir}/prefix/bin/hello_world | grep "hello, world"
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/ $out/lib/
    cp run_rustc/${outputDir}/prefix/bin/cargo $out/bin/cargo
    cp run_rustc/${outputDir}/prefix/bin/rustc_binary $out/bin/rustc

    cp -r run_rustc/${outputDir}/prefix/lib/* $out/lib/
    cp $out/lib/rustlib/${stdenv.targetPlatform.rust.rustcTarget}/lib/*.so $out/lib/
    runHook postInstall
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Minimal build of Rust";
    longDescription = ''
      A minimal build of Rust, built from source using mrustc.
      This is useful for bootstrapping the main Rust compiler without
      an initial binary toolchain download.
    '';
    maintainers = with maintainers; [
      progval
      r-burns
    ];
    license = with licenses; [
      mit
      asl20
    ];
    platforms = [ "x86_64-linux" ];
  };
}
