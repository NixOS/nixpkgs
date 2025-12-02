{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  copyDesktopItems,
  curl,
  perl,
  pkg-config,
  protobuf,
  fontconfig,
  freetype,
  libgit2,
  openssl,
  sqlite,
  zlib,
  zstd,
  alsa-lib,
  libxkbcommon,
  wayland,
  libglvnd,
  xorg,
  stdenv,
  makeFontsConf,
  vulkan-loader,
  envsubst,
  nix-update-script,
  cargo-about,
  versionCheckHook,
  buildFHSEnv,
  cargo-bundle,
  git,
  apple-sdk_15,
  darwinMinVersionHook,
  makeBinaryWrapper,
  nodejs,
  libGL,
  libX11,
  libXext,
  livekit-libwebrtc,
  testers,
  writableTmpDirAsHomeHook,

  withGLES ? false,
  buildRemoteServer ? true,
  zed-editor,
}:

assert withGLES -> stdenv.hostPlatform.isLinux;

let
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

  gpu-lib = if withGLES then libglvnd else vulkan-loader;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-editor";
  version = "0.214.7";

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
    hash = "sha256-DHKwGE5/FL3gYm9DwM1sGRsdX8kbhojLmi4B00Grtqg=";
  };

  postPatch = ''
    # Dynamically link WebRTC instead of static
    substituteInPlace $cargoDepsCopy/webrtc-sys-*/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"

    # The generate-licenses script wants a specific version of cargo-about eventhough
    # newer versions work just as well.
    substituteInPlace script/generate-licenses \
      --replace-fail '$CARGO_ABOUT_VERSION' '${cargo-about.version}'
  '';

  # remove package that has a broken Cargo.toml
  # see: https://github.com/NixOS/nixpkgs/pull/445924#issuecomment-3334648753
  depsExtraArgs.postBuild = ''
    rm -r $out/git/*/candle-book/
  '';

  cargoHash = "sha256-rkiqQKLjoWbkkDs53zqlxFx7A5Yv7AygHBXO78dRNsk=";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    curl
    perl
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    cargo-about
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeBinaryWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cargo-bundle ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    curl
    fontconfig
    freetype
    libgit2
    openssl
    sqlite
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libxkbcommon
    wayland
    xorg.libxcb
    # required by livekit:
    libGL
    libX11
    libXext
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    # ScreenCaptureKit, required by livekit, is only available on 12.3 and up:
    # https://developer.apple.com/documentation/screencapturekit
    (darwinMinVersionHook "12.3")
  ];

  cargoBuildFlags = [
    "--package=zed"
    "--package=cli"
  ]
  ++ lib.optionals buildRemoteServer [ "--package=remote_server" ];

  # Required on darwin because we don't have access to the
  # proprietary Metal shader compiler.
  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [ "gpui/runtime_shaders" ];

  env = {
    ALLOW_MISSING_LICENSES = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [
        "${finalAttrs.src}/assets/fonts/plex-mono"
        "${finalAttrs.src}/assets/fonts/plex-sans"
      ];
    };
    # Setting this environment variable allows to disable auto-updates
    # https://zed.dev/docs/development/linux#notes-for-packaging-zed
    ZED_UPDATE_EXPLANATION = "Zed has been installed using Nix. Auto-updates have thus been disabled.";
    # Used by `zed --version`
    RELEASE_VERSION = finalAttrs.version;
    LK_CUSTOM_WEBRTC = livekit-libwebrtc;
  };

  RUSTFLAGS = lib.optionalString withGLES "--cfg gles";

  preBuild = ''
    bash script/generate-licenses
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${gpu-lib}/lib $out/libexec/*
    patchelf --add-rpath ${wayland}/lib $out/libexec/*
    wrapProgram $out/libexec/zed-editor --suffix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Flaky: unreliably fails on certain hosts (including Hydra)
    "--skip=zed::tests::test_window_edit_state_restoring_enabled"
    # The following tests are flaky on at least x86_64-linux and aarch64-darwin,
    # where they sometimes fail with: "database table is locked: workspaces".
    "--skip=zed::tests::test_open_file_in_many_spaces"
    "--skip=zed::tests::test_open_non_existing_file"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: unreliably fails on certain hosts (including Hydra)
    "--skip=zed::open_listener::tests::test_open_workspace_with_directory"
    "--skip=zed::open_listener::tests::test_open_workspace_with_nonexistent_files"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Fails on certain hosts (including Hydra) for unclear reason
    "--skip=test_open_paths_action"
  ];

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

    # We're not using Zed's fork of cargo-bundle, so we must manually append their plist extensions
    # Remove closing tags from Info.plist (last two lines)
    head -n -2 $app_path/Contents/Info.plist > Info.plist
    # Append extensions
    cat resources/info/*.plist >> Info.plist
    # Add closing tags
    printf "</dict>\n</plist>\n" >> Info.plist
    mv Info.plist $app_path/Contents/Info.plist

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

    install -Dm644 $src/crates/zed/resources/app-icon@2x.png $out/share/icons/hicolor/1024x1024@2x/apps/zed.png
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
    install -Dm755 $release_target/remote_server $remote_server/bin/zed-remote-server-stable-$version
  ''
  + ''
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/zeditor";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(?!.*(?:-pre|0\.999999\.0|0\.9999-temporary)$)(.+)$"

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
        command = "zed-remote-server-stable-${finalAttrs.version} version";
      };
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      withGles = zed-editor.override { withGLES = true; };
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
