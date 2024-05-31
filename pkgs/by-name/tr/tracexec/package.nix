{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-about,
  nix-update-script,
}:
let
  pname = "tracexec";
  version = "0.4.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "kxxt";
    repo = "tracexec";
    rev = "refs/tags/v${version}";
    hash = "sha256-Rhxg3VmdMSo1xlazvToIdvkBvuFUKTq82U3PnedGHHs=";
  };

  cargoHash = "sha256-rioZfUJD4ZOpXGCWsBDQkYwW9XtTjFnGgMKl0mPF5XM=";

  nativeBuildInputs = [
    cargo-about
  ];

  # Remove RiscV64 specialisation when this is fixed:
  # * https://github.com/NixOS/nixpkgs/pull/310158#pullrequestreview-2046944158
  # * https://github.com/rust-vmm/seccompiler/pull/72
  cargoBuildFlags = lib.optional stdenv.hostPlatform.isRiscV64 "--no-default-features";

  preBuild = ''
    sed -i '1ino-clearly-defined = true' about.toml  # disable network requests
    cargo about generate --config about.toml -o THIRD_PARTY_LICENSES.HTML about.hbs
  '';

  # Tests don't work for native non-x86 compilation
  # because upstream overrides the name of the linker executables,
  # see https://github.com/NixOS/nixpkgs/pull/310158#issuecomment-2118845043
  doCheck = stdenv.hostPlatform.isx86_64;

  checkFlags = [
    "--skip=cli::test::log_mode_without_args_works" # `Permission denied` (needs `CAP_SYS_PTRACE`)
    "--skip=tracer::test::tracer_emits_exec_event" # needs `/bin/true`
  ];

  postInstall = ''
    # Remove test binaries (e.g. `empty-argv`, `corrupted-envp`) and only retain `tracexec`
    find "$out/bin" -type f \! -name tracexec -print0 | xargs -0 rm -v

    install -Dm644 LICENSE -t "$out/share/licenses/${pname}/"
    install -Dm644 THIRD_PARTY_LICENSES.HTML -t "$out/share/licenses/${pname}/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/kxxt/tracexec/blob/v${version}/CHANGELOG.md";
    description = "A small utility for tracing execve{,at} and pre-exec behavior";
    homepage = "https://github.com/kxxt/tracexec";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tracexec";
    maintainers = with lib.maintainers; [ fpletz nh2 ];
    platforms = lib.platforms.linux;
  };
}
