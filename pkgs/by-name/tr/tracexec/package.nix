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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "kxxt";
    repo = "tracexec";
    tag = "v${version}";
    hash = "sha256-j1zgHDO5bmJAXi9KvkHqenm/QfM9DmD9yNqF6TxJ9sY=";
  };

  # remove if updating to rust 1.85
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]' \
      --replace-fail 'rust-version = "1.85"' ""
  '';

  # remove if updating to rust 1.85
  env.RUSTC_BOOTSTRAP = 1;

  cargoHash = "sha256-XuuLuIeD/S60by/hg1fR+ML3PtIyX9JNrEvgGzI3UiM=";

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
