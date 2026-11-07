{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  msgpack-cxx,
  sentencepiece,
}:

let
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "tokenizers-cpp";
    tag = "v${version}";
    hash = "sha256-3IGdsmm2Pwn6T5WYUNODkrifNNB+skFbDbm1fxNjFhA=";
  };

  # Build the Rust C FFI bindings library
  tokenizers-c = rustPlatform.buildRustPackage {
    pname = "tokenizers-c";
    version = "0.1.0";
    __structuredAttrs = true;

    inherit src;
    sourceRoot = "${src.name}/rust";

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    ''
    # Rust's `dangerous_implicit_autorefs` lint (deny-by-default) rejects calling `.len()` on a
    # field reached through a raw-pointer dereference. Make the borrow explicit.
    + ''
      substituteInPlace src/lib.rs \
        --replace-fail \
          "*out_len = (*handle).decode_str.len();" \
          "*out_len = (&(*handle).decode_str).len();" \
        --replace-fail \
          "*out_len = (*handle).id_to_token_result.len();" \
          "*out_len = (&(*handle).id_to_token_result).len();"
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

  __structuredAttrs = true;
  strictDeps = true;

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
    (lib.cmakeFeature "TOKENIZERS_RUST_LIB_PATH" "${lib.getLib tokenizers-c}/lib/libtokenizers_c.a")
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
    changelog = "https://github.com/mlc-ai/tokenizers-cpp/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ JohnMolotov ];
    platforms = lib.platforms.unix;
  };
}
