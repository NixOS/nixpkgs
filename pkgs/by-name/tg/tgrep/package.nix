{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tgrep";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "tgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t+gtDMpoxuRN2K6xeztNcOJMuc4eGnF8H3sacN21UF4=";
  };

  cargoHash = "sha256-Vtqx76DHnsP6gexjTPj0hfCGHnS5yQ5xM+7RbgwrzAA=";

  __structuredAttrs = true;
  strictDeps = true;

  cargoBuildFlags = [
    "--package"
    "tgrep-cli"
  ];
  cargoTestFlags = [
    "--package"
    "tgrep-cli"
  ];
  cargoInstallFlags = [
    "--path"
    "tgrep-cli"
  ];

  nativeCheckInputs = [ git ];

  checkFlags =
    # test expects stdout to not be a tty, but the nix sandbox attaches a pty
    [
      "--skip"
      "search::tests::stats_requests_match_detail_so_spans_are_available_to_count"
    ]
    # the concurrent_search integration tests spawn `tgrep serve` and talk to it over 127.0.0.1 TCP, which the darwin sandbox blocks
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--skip"
      "concurrent_"
      "--skip"
      "server_supports_negative_lookahead_fallback"
    ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase = ''
    runHook preInstallCheck

    PATH="$out/bin:$PATH"
    mkdir -p "$TMPDIR/tgrep-install-check"
    pushd "$TMPDIR/tgrep-install-check"
    echo "the quick brown fox jumps over the lazy dog" > ./file.txt
    tgrep index .
    tgrep --color never "brown f.x" . | grep "the quick brown fox jumps over the lazy dog"
    popd

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Trigram-indexed grep with a client/server architecture for fast regex search in large codebases";
    homepage = "https://github.com/microsoft/tgrep";
    changelog = "https://github.com/microsoft/tgrep/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "tgrep";
  };
})
