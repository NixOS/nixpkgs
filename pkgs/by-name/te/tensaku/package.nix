{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  libadwaita,
  libepoxy,
  fontconfig,
  glib,
  libGL,
  libxkbcommon,
  wl-clipboard,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tensaku";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "jondkinney";
    repo = "tensaku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IAjvMaN0R+dPtdOR26uLYRT+yjpIz/ZA3V4pKa6nue4=";
  };

  cargoHash = "sha256-q+jS+NX/AKWwaidEQrJMF2hMW+UCb1XJ9zA9Tc5iH5A=";

  __structuredAttrs = true;

  # rust-toolchain.toml pins a channel for upstream's CI. There is no rustup
  # to honour it here, so remove it rather than leave a pin nothing reads.
  postPatch = ''
    rm -f rust-toolchain.toml
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    fontconfig
    glib
    gtk4
    gtk4-layer-shell
    libadwaita
    libepoxy
    libGL
    libxkbcommon
  ];

  # Without this feature build.rs writes the generated completions and man page
  # into $OUT_DIR only, where they cannot be installed from. With it they land
  # in completions/ and man/ in the build tree, which is what upstream's own
  # PKGBUILD and flatpak manifest install from.
  buildFeatures = [ "ci-release" ];

  # tensaku takes its input path as a flag, so upstream ships assets/tensaku-edit
  # to adapt the "editor <path>" convention other tools expect. It shells out to
  # wl-copy, which cannot come from the caller's PATH.
  postInstall = ''
    substituteInPlace assets/tensaku-edit \
      --replace-fail 'exec tensaku \' 'exec '"$out"'/bin/tensaku \' \
      --replace-fail '--copy-command wl-copy' '--copy-command ${lib.getExe' wl-clipboard "wl-copy"}'
    install -Dm755 assets/tensaku-edit $out/bin/tensaku-edit

    install -Dm644 dev.tensaku.Tensaku.desktop \
      $out/share/applications/dev.tensaku.Tensaku.desktop
    install -Dm644 assets/tensaku.svg \
      $out/share/icons/hicolor/scalable/apps/dev.tensaku.Tensaku.svg

    installManPage man/tensaku.1
    installShellCompletion --cmd tensaku \
      --bash completions/tensaku.bash \
      --fish completions/tensaku.fish \
      --zsh completions/_tensaku
  '';

  # The test suite wants a Wayland display and a writable HOME.
  doCheck = false;

  meta = {
    description = "Screenshot annotation tool for Wayland with movable annotations";
    homepage = "https://tensaku.dev";
    changelog = "https://github.com/jondkinney/tensaku/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "tensaku";
    maintainers = with lib.maintainers; [ joaofelipegalvao ];
    platforms = lib.platforms.linux;
  };
})
