{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  fontconfig,
  libgit2,
  openssl,
  sqlite,
  zlib,
  zstd,
  glib,
  alsa-lib,
  libxkbcommon,
  wayland,
  libxcb,
  stdenv,
  vulkan-loader,
  envsubst,
  nix-update-script,
  cargo-about,
  versionCheckHook,
  buildFHSEnv,
  cargo-bundle,
  git,
  makeBinaryWrapper,
  nodejs,
  libGL,
  libx11,
  libxext,
  livekit-libwebrtc,
  testers,
  writableTmpDirAsHomeHook,

  buildRemoteServer ? true,
}:

let
  channel = "stable";
  executableName = "zeditor";
  # Based on vscode.fhs
  # Zed allows for users to download and use extensions
  # which often include the usage of pre-built binaries.
  # See #309662
  #
  # buildFHSEnv allows for users to use the existing Zed
  # extension tooling without significant pain.
  fhs =
    {
      zed-editor,
      additionalPkgs ? pkgs: [ ],
    }:
    buildFHSEnv {
      # also determines the name of the wrapped command
      name = executableName;

      # additional libraries which are commonly needed for extensions
      targetPkgs =
        pkgs:
        (with pkgs; [
          # ld-linux-x86-64-linux.so.2 and others
          glibc
          # required by at least https://github.com/zed-industries/package-version-server
          openssl
          # required by at least the Codex CLI agent
          libcap
          zlib
        ])
        ++ additionalPkgs pkgs;

      extraBwrapArgs = [
        "--bind-try /etc/nixos/ /etc/nixos/"
        "--ro-bind-try /etc/xdg/ /etc/xdg/"
      ];

      # symlink shared assets, including icons and desktop entries
      extraInstallCommands = ''
        ln -s "${zed-editor}/share" "$out/"
      '';

      runScript = "${zed-editor}/bin/${executableName}";

      passthru = {
        inherit executableName;
        inherit (zed-editor) pname version;
      };

      meta = zed-editor.meta // {
        description = ''
          Wrapped variant of ${zed-editor.pname} which launches in a FHS compatible environment.
          Should allow for easy usage of extensions without nix-specific modifications.
        '';
      };
    };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-editor";
  version = "0.232.2";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildRemoteServer [
    "remote_server"
  ];

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S7N9R5VUcJP+yq0S6s4zeQQhSFSdDovtoL9FL1BEg2U=";
  };

  postPatch = ''
    # Disable upstream's rustflags overrides to avoid linker issues
    rm .cargo/config.toml

    # Dynamically link WebRTC instead of static
    substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"

    # The generate-licenses script wants a specific version of cargo-about eventhough
    # newer versions work just as well.
    substituteInPlace script/generate-licenses \
      --replace-fail '$CARGO_ABOUT_VERSION' '${cargo-about.version}'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # webrtc-sys expects glib headers to be in the sysroot, so we have to point it in the right direction
    substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
      --replace-fail 'builder.include(&glib_path);' 'builder.include("${lib.getInclude glib}/include/glib-2.0");' \
      --replace-fail 'builder.include(&glib_path_config);' 'builder.include("${lib.getLib glib}/lib/glib-2.0/include");'
  '';

  # remove package that has a broken Cargo.toml
  # see: https://github.com/NixOS/nixpkgs/pull/445924#issuecomment-3334648753
  depsExtraArgs.postBuild = ''
    rm -r $out/git/*/candle-book/
  '';

  cargoHash = "sha256-WpEPQw3GOemxjyfDH7VH3FURpkYVfVyXQiALJsccwQ4=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    cargo-about
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeBinaryWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cargo-bundle ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libgit2
    sqlite
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    openssl
    glib
    alsa-lib
    libxkbcommon
    wayland
    libxcb
    # required by livekit:
    libGL
    libx11
    libxext
  ];

  cargoBuildFlags = [
    "--package=zed"
    "--package=cli"
  ]
  ++ lib.optionals buildRemoteServer [ "--package=remote_server" ];

  # Required on darwin because we don't have access to the
  # proprietary Metal shader compiler.
  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [ "gpui_platform/runtime_shaders" ];

  # Some crates define extra types or enum values in test configuration which then lead
  # to type checking errors in other crates unless this feature is enabled.
  # gpui_platform/runtime_shaders is required on darwin for the same reason as buildFeatures above:
  # without it, build.rs invokes the proprietary Metal shader compiler.
  checkFeatures = [
    "visual-tests"
  ]
  ++ finalAttrs.buildFeatures;

  env = {
    ALLOW_MISSING_LICENSES = true;
    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    # Setting this environment variable allows to disable auto-updates
    # https://zed.dev/docs/development/linux#notes-for-packaging-zed
    ZED_UPDATE_EXPLANATION = "Zed has been installed using Nix. Auto-updates have thus been disabled.";
    # Used by `zed --version`
    RELEASE_VERSION = finalAttrs.version;
    LK_CUSTOM_WEBRTC = livekit-libwebrtc;
  };

  preBuild = ''
    bash script/generate-licenses
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/libexec/zed-editor --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }
    wrapProgram $out/libexec/zed-editor --suffix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # These two tests trigger GUI prompts that hang in the headless Nix build sandbox.
  checkFlags = [
    "--skip"
    "zed::open_listener::tests::test_e2e_prompt_user_picks_existing_window"
    "--skip"
    "zed::open_listener::tests::test_e2e_prompt_user_picks_new_window"
  ];

  useNextest = true;

  remoteServerExecutableName = "zed-remote-server-${channel}-${finalAttrs.version}+${channel}";
  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # cargo-bundle expects the binary in target/release
    mv $release_target/zed target/release/zed

    pushd crates/zed
    # Note that this is GNU sed, while Zed's bundle-mac uses BSD sed
    sed -i "s/package.metadata.bundle-stable/package.metadata.bundle/" Cargo.toml
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    popd

    mkdir -p $out/Applications $out/bin
    # Zed expects git next to its own binary
    ln -s ${lib.getExe git} $app_path/Contents/MacOS/git
    mv $release_target/cli $app_path/Contents/MacOS/cli
    mv $app_path $out/Applications/

    # Physical location of the CLI must be inside the app bundle as this is used
    # to determine which app to start
    ln -s $out/Applications/Zed.app/Contents/MacOS/cli $out/bin/zeditor
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 $release_target/zed $out/libexec/zed-editor
    install -Dm755 $release_target/cli $out/bin/zeditor

    install -Dm644 $src/crates/zed/resources/app-icon@2x.png $out/share/icons/hicolor/512x512@2/apps/zed.png
    install -Dm644 $src/crates/zed/resources/app-icon.png $out/share/icons/hicolor/512x512/apps/zed.png

    # extracted from https://github.com/zed-industries/zed/blob/v0.141.2/script/bundle-linux (envsubst)
    # and https://github.com/zed-industries/zed/blob/v0.141.2/script/install.sh (final desktop file name)
    (
      export DO_STARTUP_NOTIFY="true"
      export APP_CLI="zeditor"
      export APP_ICON="zed"
      export APP_NAME="Zed"
      export APP_ARGS="%U"
      mkdir -p "$out/share/applications"
      ${lib.getExe envsubst} < "crates/zed/resources/zed.desktop.in" > "$out/share/applications/dev.zed.Zed.desktop"
    )
  ''
  + lib.optionalString buildRemoteServer ''
    install -Dm755 $release_target/remote_server $remote_server/bin/${finalAttrs.remoteServerExecutableName}
  ''
  + ''
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/zeditor";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(?!.*(?:-pre|0\\.999999\\.0|0\\.9999-temporary)$)(.+)$"

        # use github releases instead of git tags
        # zed sometimes moves git tags, making them unreliable
        # see: https://github.com/NixOS/nixpkgs/pull/439893#issuecomment-3250497178
        "--use-github-releases"
      ];
    };
    fhs = fhs { zed-editor = finalAttrs.finalPackage; };
    fhsWithPackages =
      f:
      fhs {
        zed-editor = finalAttrs.finalPackage;
        additionalPkgs = f;
      };
    tests = {
      remoteServerVersion = testers.testVersion {
        package = finalAttrs.finalPackage.remote_server;
        command = "${finalAttrs.remoteServerExecutableName} version";
      };
    };
  };

  meta = {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    changelog = "https://github.com/zed-industries/zed/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      niklaskorz
    ];
    mainProgram = "zeditor";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
