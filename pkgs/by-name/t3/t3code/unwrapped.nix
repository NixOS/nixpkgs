{
  autoPatchelfHook,
  callPackage,
  cctools,
  copyDesktopItems,
  electron_44,
  fetchFromGitHub,
  installShellFiles,
  jq,
  lib,
  libicns,
  libsecret,
  makeBinaryWrapper,
  makeDesktopItem,
  nix-update-script,
  node-gyp,
  nodejs_26,
  pkg-config,
  python3,
  spdx-license-list-data,
  stdenv,
  vulkan-loader,
  writeDarwinBundle,
  xcbuild,
  fetchPnpmDeps,
  pnpm_12,
  pnpmConfigHook,
  pnpmBuildHook,
  cacert,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    appName = "T3 Code (Beta)";
    electron = electron_44;
    # Upstream package.json requires Node.js 26; the nixpkgs default is still 24.
    nodejs = nodejs_26;
    pnpm = pnpm_12;
    captureHelpers = lib.genAttrs [ "kde" "hyprland" ] (
      backend:
      callPackage ./capture-helper.nix {
        inherit backend;
        inherit (finalAttrs) src version;
      }
    );
    desktopIcon =
      if stdenv.hostPlatform.isDarwin then
        "assets/prod/black-macos-1024.png"
      else
        "assets/prod/black-universal-1024.png";

  in
  {
    pname = "t3code-unwrapped";
    version = "0.1.11";
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-oI8gyTWFgtTmVK+0cVQaEcfO8EzxUUOW5s8JFG/z/U8=";
    };

    postPatch = ''
      substituteInPlace apps/web/vite.config.ts \
        --replace-fail 'const host = explicitHost || "localhost";' \
                       'const host = explicitHost || "127.0.0.1";'

      mkdir -p .generated/third-party-licenses/spdx/v3.28.0
      cp ${spdx-license-list-data.json}/json/details/*.json \
        .generated/third-party-licenses/spdx/v3.28.0
    '';

    nativeBuildInputs = [
      installShellFiles
      jq
      makeBinaryWrapper
      node-gyp
      nodejs
      python3
      pnpmConfigHook
      pnpmBuildHook
      pnpm
      cacert
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      copyDesktopItems
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools.libtool
      libicns
      writeDarwinBundle
      xcbuild
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      libsecret
      stdenv.cc.cc.lib
      vulkan-loader
    ];

    pnpmWorkspaces = [
      # `...` suffix is used to also include other workspace packages that are
      # directly or indirectly depended on by the listed packages, such as
      # `@t3tools/contracts` and `@t3tools/shared`.
      "@t3tools/monorepo"
      "t3..."
      "@t3tools/desktop..."
      "@t3tools/scripts..."
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit pnpm;
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;

      fetcherVersion = 5;
      hash = "sha256-s/vm8Ox4o/AYpNC/amYP1KFWwh7SY5bCmVBuIJn9f/c=";
    };

    preBuild = ''
      # pnpm otherwise detects the package version updates below as
      # dependency drift and runs another install, including lifecycle scripts.
      export pnpm_config_verify_deps_before_run=false

      node scripts/update-release-package-versions.ts ${finalAttrs.version}

      export npm_config_nodedir=${nodejs}
      export ELECTRON_SKIP_BINARY_DOWNLOAD=1
      # Exclude the `@t3tools/monorepo` workspace from the pending rebuild since
      # `vp config` needs git
      pnpm rebuild --pending "''${pnpmInstallFlags[@]}" --filter '!@t3tools/monorepo'

      # pnpmConfigHook only patches root node_modules. Workspace shims must also
      # use Nix's shell: macOS /bin/sh breaks pnpm's sandbox helper lookup.
      patchShebangs apps/*/node_modules packages/*/node_modules scripts/node_modules
    '';

    pnpmBuildScript = "build:desktop";

    postBuild = ''
      pnpm vp cache clean
    '';

    # The pnpm tree includes static, musl, and foreign-platform binaries.
    # Generic RPATH fixups cannot inspect some of these static prebuilds.
    dontPatchELF = true;
    # The tmpdir audit also runs patchelf on every ELF, causing spurious errors.
    noAuditTmpdir = true;
    # Patch only host modules in postFixup, avoiding unrelated musl dependencies.
    dontAutoPatchelf = true;
    # Speech backends load sibling libraries relative to their own directory.
    autoPatchelfFlags = [ "--preserve-origin" ];

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/libexec/t3code/apps/desktop "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode node_modules "$out"/libexec/t3code
      cp --recursive --no-preserve=mode apps/server/{node_modules,dist} "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode \
        apps/desktop/{node_modules,dist-electron} \
        "$out"/libexec/t3code/apps/desktop

      # Electron derives the app name, and with it the safeStorage keyring /
      # Keychain identity, from `productName` or `name`. Use `t3code` like the
      # official builds so encrypted data stays readable across rebrands.
      jq '.name = "t3code" | del(.productName)' apps/desktop/package.json \
        > "$out"/libexec/t3code/apps/desktop/package.json

      mkdir --parents "$out"/libexec/t3code/apps/desktop/prod-resources
      install --mode=444 ${desktopIcon} \
        "$out"/libexec/t3code/apps/desktop/prod-resources/icon.png
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm755 \
        native/browser-secret/build/${stdenv.hostPlatform.node.arch}/t3-browser-secret \
        "$out"/libexec/t3code/apps/desktop/prod-resources/browser-secret/t3-browser-secret

      # Shared Electron uses the unpackaged resource paths in DesktopSnapShot.
      while IFS= read -r file; do
        install -Dm444 "apps/desktop/gnome-extension/$file" \
          "$out/libexec/t3code/apps/desktop/gnome-extension/$file"
      done < <(jq -r '.files[]' apps/desktop/gnome-extension/bundle.json)

      # The setup code rejects symlinks, including for bundled helpers.
      install -Dm755 ${lib.getExe captureHelpers.kde} \
        "$out/libexec/t3code/native/kde-snap-shot/target/release/t3-kde-snap-shot"
      install -Dm755 ${lib.getExe captureHelpers.hyprland} \
        "$out/libexec/t3code/native/hyprland-snap-shot/target/release/t3-hyprland-snap-shot"
      cp -r ${captureHelpers.hyprland}/share/t3code/hyprland-capture/protocols \
        "$out/libexec/t3code/native/hyprland-snap-shot/"
    ''
    + ''

      find "$out"/libexec/t3code -xtype l -delete

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3 \
        --add-flags "$out"/libexec/t3code/apps/server/dist/bin.mjs

      makeWrapper ${lib.getExe electron} "$out"/bin/t3code-desktop \
        --add-flags "$out"/libexec/t3code/apps/desktop \
        --set-default T3CODE_DESKTOP_LAUNCHER_PATH "$out/bin/t3code-desktop" \
        --inherit-argv0
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Match upstream's single-architecture bundle exclusions, including objc-js.
      find "$out/libexec/t3code" -type d \
        -path '*/prebuilds/darwin-${if stdenv.hostPlatform.isAarch64 then "x64" else "arm64"}' \
        -prune -exec rm -rf {} +

      # node-pty tries to chmod this helper at runtime, but the Nix store is
      # immutable by then.
      find "$out"/libexec/t3code \
        -path '*/node-pty/prebuilds/darwin-*/spawn-helper' \
        -exec chmod 755 {} +

      mkdir --parents "$out/Applications/${appName}.app/Contents/"{MacOS,Resources}
      png2icns \
        "$out/Applications/${appName}.app/Contents/Resources/t3code.icns" \
        ${desktopIcon}

      # writeDarwinBundle is a shebangless bash script; run it explicitly via
      # stdenv.shell to avoid Darwin's intermittent ENOEXEC fallback issues.
      ${stdenv.shell} ${lib.getExe writeDarwinBundle} \
        "$out" "${appName}" t3code-desktop t3code

      # Import upstream's usage descriptions without running its packaging CLI.
      pnpm --dir scripts exec node --input-type=module - \
        "$out/Applications/${appName}.app/Contents/Info.plist" <<'EOF'
      import { readFileSync, writeFileSync } from "node:fs";
      import { Effect, Path } from "effect";
      import plist from "plist";
      import { createBuildConfig } from "./build-desktop-artifact.ts";

      const config = createBuildConfig("mac", "dir", "${finalAttrs.version}", false, false);
      const { mac } = await Effect.runPromise(Effect.provide(config, Path.layer));
      const file = process.argv[2];
      const info = plist.parse(readFileSync(file, "utf8"));
      for (const [key, value] of Object.entries(mac.extendInfo)) {
        if (/^NS.*UsageDescription$/.test(key)) info[key] = value;
      }
      writeFileSync(file, plist.build(info));
      EOF
    ''
    + ''
      mkdir --parents \
        "$out"/share/icons/hicolor/{1024x1024,scalable}/apps
      install --mode=444 ${desktopIcon} \
        "$out"/share/icons/hicolor/1024x1024/apps/t3code.png
      install --mode=444 assets/prod/logo.svg \
        "$out"/share/icons/hicolor/scalable/apps/t3code.svg

      runHook postInstall
    '';

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        installShellCompletion --cmd t3 --"$shell" <("$out/bin/t3" --completions "$shell")
      done
    '';

    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      # Resolve libstdc++ and Vulkan through buildInputs, retaining $ORIGIN for
      # the speech library's sibling ggml libraries.
      autoPatchelf \
        "$out"/libexec/t3code/node_modules/.pnpm/node-pty@*/node_modules/node-pty/prebuilds/linux-${stdenv.hostPlatform.node.arch} \
        "$out"/libexec/t3code/node_modules/.pnpm/@koromix+koffi-linux-${stdenv.hostPlatform.node.arch}@*/node_modules/@koromix/koffi-linux-${stdenv.hostPlatform.node.arch}/linux_${stdenv.hostPlatform.node.arch} \
        "$out"/libexec/t3code/node_modules/.pnpm/@transcribe-cpp+linux-${stdenv.hostPlatform.node.arch}-cpu-vulkan@*/node_modules/@transcribe-cpp/linux-${stdenv.hostPlatform.node.arch}-cpu-vulkan
    '';

    doInstallCheck = stdenv.hostPlatform.isLinux && stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    installCheckPhase = ''
      runHook preInstallCheck

      # The standalone Node CLI can mask missing C++ runtime dependencies;
      # exercise local dictation with the same runtime as the desktop worker.
      ELECTRON_RUN_AS_NODE=1 ${lib.getExe electron} --input-type=module -e '
        const speech = await import(process.argv[1]);
        if (!speech.getAvailableBackends().some(backend => backend.kind === "cpu")) {
          throw new Error("Native speech CPU backend is unavailable");
        }
      ' "$out/libexec/t3code/apps/server/node_modules/transcribe-cpp/dist/index.js"

      runHook postInstallCheck
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "t3code";
        desktopName = appName;
        comment = "Minimal web GUI for coding agents";
        exec = "t3code-desktop %U";
        terminal = false;
        icon = "t3code";
        startupWMClass = "com.t3tools.T3Code";
        categories = [ "Development" ];
        mimeTypes = [ "x-scheme-handler/t3code" ];
      })
    ];

    passthru = {
      inherit captureHelpers;
      updateScript = nix-update-script {
        attrPath = "t3code.unwrapped";
        extraArgs = [ "--use-github-releases" ];
      };
    };

    meta = {
      description = "Minimal web GUI for coding agents";
      homepage = "https://t3.codes";
      downloadPage = "https://t3.codes/download";
      changelog = "https://github.com/pingdotgg/t3code/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        _0x4bs3nt
        iamanaws
        qweered
      ];
      mainProgram = "t3code-desktop";
      inherit (nodejs.meta) platforms;
    };
  }
)
