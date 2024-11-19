{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  installShellFiles,
  pkg-config,
  curl,
  openssl,
  mandown,
  zellij,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.41.2";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    hash = "sha256-xdWfaXWmqFJuquE7n3moUjGuFqKB90OE6lqPuC3onOg=";
  };

  # Remove the `vendored_curl` feature in order to link against the libcurl from nixpkgs instead of
  # the vendored one
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail ', "vendored_curl"' ""
  '';

  cargoHash = "sha256-38hTOsa1a5vpR1i8GK1aq1b8qaJoCE74ewbUOnun+Qs=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    mandown
    installShellFiles
    pkg-config
    (lib.getDev curl)
  ];

  buildInputs = [
    curl
    openssl
  ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  # Ensure that we don't vendor curl, but instead link against the libcurl from nixpkgs
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/zellij" | grep libcurl.so

    runHook postInstallCheck
  '';

  postInstall =
    ''
      mandown docs/MANPAGE.md > zellij.1
      installManPage zellij.1
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd $pname \
        --bash <($out/bin/zellij setup --generate-completion bash) \
        --fish <($out/bin/zellij setup --generate-completion fish) \
        --zsh <($out/bin/zellij setup --generate-completion zsh)
    '';

  passthru.tests.version = testers.testVersion { package = zellij; };

  meta = with lib; {
    description = "Terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      therealansh
      _0x4A6F
      abbe
      pyrox0
    ];
    mainProgram = "zellij";
  };
}
