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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tracexec";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "kxxt";
    repo = "tracexec";
    rev = "ecbda651a4006789debf565376cd6f37241dec3e";
    hash = "sha256-wP7jAGoWgvm3/4XBHr27MD8M9qwyVpuDVR96S8+I3eo=";
  };

  cargoHash = "sha256-kJrWAyRcU5eEfTwaAxcN6oE5KHgBdjznWeI21/3c/UE=";

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
  ];

  preBuild = ''
    sed -i '1ino-clearly-defined = true' about.toml  # disable network requests
    cargo about generate --config about.toml -o THIRD_PARTY_LICENSES.HTML about.hbs
  '';

  checkFlags = [
    "--skip=log_mode_without_args_works" # `Permission denied` (needs `CAP_SYS_PTRACE`)
  ];

  postInstall = ''
    # Remove test binaries (e.g. `empty-argv`, `corrupted-envp`) and only retain `tracexec`
    find "$out/bin" -type f \! -name tracexec -print0 | xargs -0 rm -v

    install -Dm644 LICENSE -t "$out/share/licenses/tracexec/"
    install -Dm644 THIRD_PARTY_LICENSES.HTML -t "$out/share/licenses/tracexec/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/kxxt/tracexec/blob/v${finalAttrs.version}/CHANGELOG.md";
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
})
