{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-about,
  nix-update-script,
  pkg-config,
  libbpf,
  elfutils,
  libseccomp,
  zlib,
  clang,
}:

rustPlatform.buildRustPackage rec {
  pname = "tracexec";
  version = "0.13.0-unstable-2025-09-07";

  src = fetchFromGitHub {
    owner = "kxxt";
    repo = "tracexec";
    rev = "dbb9b733370f5200df2a0de7f007312c23431480";
    hash = "sha256-M2ZIfWupnFxQZvr5cl8V0xtLgh+xBcaHHVsHIoio7nI=";
  };

  cargoHash = "sha256-cyzSxibLw6sb0V3ueNcp55OhFQ5jUNJWcSF8uYnzG2M=";

  hardeningDisable = [ "zerocallusedregs" ];

  nativeBuildInputs = [
    cargo-about
    pkg-config
    clang
  ];

  buildInputs = [
    libbpf
    elfutils
    libseccomp
    zlib
  ];

  cargoBuildFlags = [
    "--no-default-features"
    "--features=recommended"
  ]
  # Remove RiscV64 specialisation when this is fixed:
  # * https://github.com/NixOS/nixpkgs/pull/310158#pullrequestreview-2046944158
  # * https://github.com/rust-vmm/seccompiler/pull/72
  ++ lib.optional stdenv.hostPlatform.isRiscV64 "--no-default-features";

  preBuild = ''
    sed -i '1ino-clearly-defined = true' about.toml  # disable network requests
    cargo about generate --config about.toml -o THIRD_PARTY_LICENSES.HTML about.hbs
  '';

  checkFlags = [
    "--skip=cli::test::log_mode_without_args_works" # `Permission denied` (needs `CAP_SYS_PTRACE`)
  ];

  postInstall = ''
    # Remove test binaries (e.g. `empty-argv`, `corrupted-envp`) and only retain `tracexec`
    find "$out/bin" -type f \! -name tracexec -print0 | xargs -0 rm -v

    install -Dm644 LICENSE -t "$out/share/licenses/tracexec/"
    install -Dm644 THIRD_PARTY_LICENSES.HTML -t "$out/share/licenses/tracexec/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/kxxt/tracexec/blob/v${version}/CHANGELOG.md";
    description = "Small utility for tracing execve{,at} and pre-exec behavior";
    homepage = "https://github.com/kxxt/tracexec";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tracexec";
    maintainers = with lib.maintainers; [
      fpletz
      nh2
    ];
    platforms = lib.platforms.linux;
  };
}
