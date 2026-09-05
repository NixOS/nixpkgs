{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  rclone,
  restic,
  writableTmpDirAsHomeHook,
  nixosTests,
}:

let
  buildNodeModules =
    finalAttrs:
    stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        bun install \
          --cpu="*" \
          --os="*" \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress
        bun --bun ${./canonicalize-node-modules.ts}
        bun --bun ${./normalize-bun-binaries.ts}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R ./node_modules $out/node_modules
        # Keep workspace packages so the workspace symlinks inside
        # node_modules keep resolving.
        cp -R ./packages $out/packages

        # Windows executables are never used on the supported platforms and
        # can be quarantined by endpoint security software.
        find $out -type f -name '*.exe' -delete

        runHook postInstall
      '';

      # Required, otherwise the fixed-output derivation references store paths.
      dontFixup = true;

      outputHash = "sha256-4fMmwxknyj2jwDyooT3WAzHXW2J5uxi6LsHdOoFte0k=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zerobyte";
  version = "0.42.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nicotsx";
    repo = "zerobyte";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gueZUwoEetsEuAG5QXvLgUUrib79sk2azcmD0XZMhQo=";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    nodejs
    writableTmpDirAsHomeHook
  ];

  # Displayed in the web interface.
  env = {
    VITE_APP_VERSION = finalAttrs.version;
    VITE_RESTIC_VERSION = restic.version;
    VITE_RCLONE_VERSION = rclone.version;
  };

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/node_modules ./node_modules
    cp -R ${finalAttrs.passthru.node_modules}/packages ./packages
    chmod -R u+w ./node_modules ./packages
    patchShebangs --build ./node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build
    bun build apps/agent/src/index.ts --outfile .output/agent/index.mjs --target bun

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/zerobyte
    cp -R .output $out/lib/zerobyte/.output
    cp package.json $out/lib/zerobyte/package.json
    # Database migrations, loaded by the server at startup.
    cp -R app/drizzle $out/lib/zerobyte/migrations

    makeBinaryWrapper ${lib.getExe bun} $out/bin/zerobyte \
      --chdir "$out/lib/zerobyte" \
      --prefix PATH : ${
        lib.makeBinPath [
          bun
          restic
          rclone
        ]
      } \
      --set NODE_ENV "production" \
      --set APP_VERSION "${finalAttrs.version}" \
      --set-default MIGRATIONS_PATH "$out/lib/zerobyte/migrations" \
      --add-flags "$out/lib/zerobyte/.output/server/index.mjs"

    install -Dm644 LICENSE $out/share/doc/zerobyte/LICENSE
    install -Dm644 NOTICES.md $out/share/doc/zerobyte/NOTICES.md
    cp -R LICENSES $out/share/doc/zerobyte/LICENSES

    runHook postInstall
  '';

  passthru = {
    node_modules = buildNodeModules finalAttrs;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
    tests = {
      inherit (nixosTests) zerobyte;
    };
  };

  meta = {
    description = "Backup automation for self-hosters, built on top of restic";
    homepage = "https://github.com/nicotsx/zerobyte";
    changelog = "https://github.com/nicotsx/zerobyte/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "zerobyte";
  };
})
