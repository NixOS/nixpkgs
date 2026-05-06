{
  lib,
  stdenv,
  fetchgit,
  rustPlatform,
  cmake,
  pkg-config,
  msgpack-cxx,
  sentencepiece,
}:

let
  version = "0-unstable-2025-03-18";

  src = fetchgit {
    url = "https://github.com/mlc-ai/tokenizers-cpp";
    rev = "acbdc5a27ae01ba74cda756f94da698d40f11dfe";
    hash = "sha256-/Y9FphwL0zs9hXyfvEbDbaDKAzy/hJ9qlSpUzViuDo8=";
  };

  # Build the Rust C FFI bindings library
  tokenizers-c = rustPlatform.buildRustPackage {
    pname = "tokenizers-c";
    version = "0.1.0";

    inherit src;
    sourceRoot = "${src.name}/rust";

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    postPatch = ''
      cp --no-preserve=mode ${./Cargo.lock} Cargo.lock
    '';

    meta = {
      description = "C FFI bindings for the Hugging Face tokenizers library";
      homepage = "https://github.com/mlc-ai/tokenizers-cpp";
      license = lib.licenses.asl20;
      platforms = lib.platforms.unix;
    };
  };
in
stdenv.mkDerivation {
  pname = "tokenizers-cpp";
  inherit version src;

  patches = [ ./use-system-libs.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    msgpack-cxx
    sentencepiece
    tokenizers-c
  ];

  cmakeFlags = [
    "-DTOKENIZERS_RUST_LIB_PATH=${tokenizers-c}/lib/libtokenizers_c.a"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/include
    cp libtokenizers_cpp.a $out/lib/
    cp -r ${src}/include/* $out/include/
    runHook postInstall
  '';

  passthru = {
    inherit tokenizers-c;
  };

  meta = {
    description = "C++ wrapper for Hugging Face tokenizers with cross-platform support";
    homepage = "https://github.com/mlc-ai/tokenizers-cpp";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
