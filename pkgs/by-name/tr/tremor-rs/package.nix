{
  lib,
  rustPlatform,
  pkg-config,
  cmake,
  openssl,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  libiconv,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "tremor";
  version = "0.13.0-rc.33";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-runtime";
    rev = "v${version}";
    hash = "sha256-DoFqHKTu4CvgDYPT4vbwNvSZ/lNTdAF+wlHOOIBJKUw=";
  };

  cargoHash = "sha256-w/d/MMd5JNQMRUxRaH4Tpf4Dzh14eykG+zzuM/YrU40=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # relax lints to fix an error caused by invalid macro_export
  # error: `log_error` isn't a valid `#[macro_export]` argument
  # note: `#[deny(invalid_macro_export_arguments)]` implied by `#[deny(warnings)]`
  postPatch = ''
    shopt -s globstar
    substituteInPlace **/*.rs \
      --replace-quiet '#![deny(warnings)]' ""
    shopt -u globstar
  '';

  # TODO export TREMOR_PATH($out/lib) variable
  postInstall = ''
    # Copy the standard library to $out/lib
    cp -r ${src}/tremor-script/lib/ $out

  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tremor \
      --bash <($out/bin/tremor completions bash) \
      --fish <($out/bin/tremor completions fish) \
      --zsh <($out/bin/tremor completions zsh)
  '';

  # OPENSSL_NO_VENDOR - If set, always find OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  env = lib.optionalAttrs (stdenv.system == "x86_64-darwin") {
    RUSTFLAGS = "-C target-feature=+avx,+avx2,+sse4.2";
  };

  # tests failed on x86_64-darwin with SIGILL: illegal instruction
  doCheck = stdenv.system != "x86_64-darwin";

  checkFlags = [
    # all try to make a network access
    "--skip=connectors::tests::http::server::https_server_test"
    "--skip=connectors::tests::tcp::client::tls_client"
    "--skip=connectors::tests::udp::udp_no_bind"
    "--skip=connectors::tests::ws::ws_client_bad_config"
    "--skip=connectors::tests::ws::wss_server_binary_routing"
    "--skip=connectors::tests::ws::wss_server_text_routing"
    "--skip=connectors::utils::tls::tests::client_config"
  ];

  cargoBuildFlags = [ "-p tremor-cli" ];

  meta = with lib; {
    description = ''
      Early stage event processing system for unstructured data with rich
      support for structural pattern matching, filtering and transformation
    '';
    homepage = "https://www.tremor.rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      humancalico
      happysalada
    ];
  };
}
