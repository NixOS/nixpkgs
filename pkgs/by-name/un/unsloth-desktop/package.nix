{
  lib,
  rustPlatform,
  bashInteractive,
  cacert,
  buildFHSEnv,
  cargo-tauri,
  coreutils,
  dpkg,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  nodejs_24,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  zsh,
}:

let
  version = "0.1.913-beta";

  unsloth-desktop-unwrapped = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "unsloth-desktop-unwrapped";
    inherit version;

    src = fetchFromGitHub {
      owner = "unslothai";
      repo = "unsloth";
      tag = "v${finalAttrs.version}";
      hash = "sha256-JAswrvmUfg1V976YBmA/XSrXD02PtV+0/tLmDKxQIkA=";
    };

    cargoRoot = "studio/src-tauri";
    buildAndTestSubdir = finalAttrs.cargoRoot;
    cargoHash = "sha256-LxEmOwuXJEQpUzixaD3z43ZoIiyinjnMn/s0Ksr9VGY=";

    npmRoot = "studio/frontend";
    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
      inherit (finalAttrs) src;
      sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
      hash = "sha256-mTnOkuMnitJPnysaIyWW9OA2xJ/IVBOSvH3Xm9/CD6A=";
    };

    cargoBuildFlags = [
      "--config"
      "profile.release.strip=true"
    ];

    nativeBuildInputs = [
      cargo-tauri.hook
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      nodejs_24
      npmHooks.npmConfigHook
      pkg-config
      wrapGAppsHook4
    ];

    buildInputs = [
      glib-networking
      libayatana-appindicator
      openssl
      webkitgtk_4_1
    ];

    nativeCheckInputs = [
      bashInteractive
      cacert
      dpkg
      zsh
    ];

    # Tests changing the process-wide PATH interfere with other tests' children.
    dontUseCargoParallelTests = true;

    postPatch = ''
      substituteInPlace studio/src-tauri/tauri.conf.json \
        --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'

      # The environment isolation tests invoke env with a custom PATH.
      substituteInPlace studio/src-tauri/src/process.rs \
        --replace-fail '"/usr/bin/env"' '"${lib.getExe' coreutils "env"}"'

      # The Debian updater tests expect package management tools in /usr/bin.
      substituteInPlace studio/src-tauri/src/debian_update.rs \
        --replace-fail '/usr/bin/dpkg-query' '${lib.getExe' dpkg "dpkg-query"}' \
        --replace-fail 'system_command("/usr/bin/dpkg")' 'system_command("${lib.getExe dpkg}")'

      # Exercise the history preservation tests with shells and env from the store.
      substituteInPlace studio/src-tauri/src/shell_path.rs \
        --replace-fail '["/bin", "/usr/bin", "/usr/local/bin", "/opt/homebrew/bin"]' \
          '["${lib.getBin bashInteractive}/bin", "${lib.getBin zsh}/bin"]' \
        --replace-fail '.env("PATH", "/usr/bin:/bin")' '.env("PATH", "${lib.getBin coreutils}/bin")'
    '';

    preBuild = ''
      # Upstream stamps the release version into these placeholders in CI.
      # This cannot be in postPatch or else cargoSetupPostPatchHook complains
      # about inconsistency between Cargo.lock and its vendored version.
      substituteInPlace studio/src-tauri/Cargo.toml studio/src-tauri/Cargo.lock \
        --replace-fail 'version = "2026.4.8"' 'version = "${finalAttrs.version}"'
    '';

    meta = {
      description = "Desktop application for running and training AI models locally (unwrapped)";
      homepage = "https://unsloth.ai/";
      license = lib.licenses.agpl3Only;
      platforms = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
    };
  });
in
buildFHSEnv {
  pname = "unsloth-desktop";
  inherit version;
  __structuredAttrs = true;

  includeClosures = true;

  targetPkgs =
    pkgs: with pkgs; [
      webkitgtk_4_1
      gtk3
      libsoup_3
      glib-networking
      gsettings-desktop-schemas
      hicolor-icon-theme
      shared-mime-info
      libayatana-appindicator
      libnghttp2
      nodejs_24
      cacert
      gcc
      pciutils
    ];

  profile = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    export CC=gcc
  '';

  runScript = "${unsloth-desktop-unwrapped}/bin/unsloth-studio";

  extraInstallCommands = ''
    install -Dm644 ${unsloth-desktop-unwrapped}/share/applications/Unsloth.desktop \
      $out/share/applications/unsloth-desktop.desktop
    substituteInPlace $out/share/applications/unsloth-desktop.desktop \
      --replace-fail "Exec=unsloth-studio" "Exec=unsloth-desktop"
    install -Dm644 ${unsloth-desktop-unwrapped}/share/icons/hicolor/128x128/apps/unsloth-studio.png \
      $out/share/icons/hicolor/128x128/apps/unsloth-studio.png
  '';

  passthru = {
    inherit unsloth-desktop-unwrapped;
    updateScript = nix-update-script {
      attrPath = "unsloth-desktop.unsloth-desktop-unwrapped";
      extraArgs = [ "--version=unstable" ];
    };
  };

  meta = {
    description = "Desktop application for running and training AI models locally";
    homepage = "https://unsloth.ai/";
    changelog = "https://github.com/unslothai/unsloth/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ parry-97 ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    mainProgram = "unsloth-desktop";
    longDescription = ''
      Builds Unsloth Desktop from source and wraps it in an FHS environment.

      The app manages its own runtime in ~/.unsloth/studio: on first run it
      bootstraps a uv venv, installs the unsloth PyPI backend and PyTorch
      (CUDA wheels selected by GPU), and downloads prebuilt llama.cpp binaries.
      These runtime components are not part of this package.

      Note: the in-app self-updater cannot replace the read-only store binary;
      update by rebuilding this package.
    '';
  };
}
