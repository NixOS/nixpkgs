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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kxxt";
    repo = "tracexec";
    rev = "c3f95dcf7714dc731f494683ef7f74e399a22515";
    hash = "sha256-VDmBCloMTDXxRSIOt4Pu0U6GgaOU0vp2s2zLbd4j7Ds=";
  };

  cargoHash = "sha256-YhSaRVgYnIcH1tHn8wPi/yeNnOzV0MvHyeZXn1s8jGA=";

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

  # tracexec uses $XDG_DATA_HOME/tracexec for storing temporary files and logs.
  # Set this directory to $TMPDIR because integration tests needs to access it.
  preCheck = ''
    export TRACEXEC_DATA="$TMPDIR"
  '';

  postInstall = ''
    # Remove test binaries (e.g. `empty-argv`, `corrupted-envp`) and only retain `tracexec`
    find "$out/bin" -type f \! -name tracexec -print0 | xargs -0 rm -v

    install -Dm644 LICENSE -t "$out/share/licenses/tracexec/"
    install -Dm644 THIRD_PARTY_LICENSES.HTML -t "$out/share/licenses/tracexec/"
    install -Dm644 themes/*.toml -t "$out/share/tracexec/themes/"
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
      kxxt
      nh2
    ];
    platforms = lib.platforms.linux;
  };
})
