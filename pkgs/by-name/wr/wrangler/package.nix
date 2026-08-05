{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  autoPatchelfHook,
  cacert,
  llvmPackages,
  musl,
  libx11,
  jq,
  moreutils,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wrangler";
  version = "4.93.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "wrangler@${finalAttrs.version}";
    hash = "sha256-o/kD67hkj+/pr1grCmTsrWUggcusRWoHegbL4hIEdAw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-bc/L3bQl2BlcoqpTGBrFbGNl8IeRPoV65EVykAa8euA=";
  };
  # pnpm packageManager version in workers-sdk root package.json may not match nixpkgs
  postPatch = ''
    jq 'del(.packageManager)' package.json | sponge package.json
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=wrangler@(.*)"
    ];
  };

  buildInputs = [
    llvmPackages.libcxx
    llvmPackages.libunwind
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    musl # not used, but requires extra work to remove
    libx11 # for the clipboardy package
  ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
    jq
    moreutils
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    autoPatchelfHook
  ];

  # @cloudflare/vitest-pool-workers wanted to run a server as part of the build process
  # so I simply removed it
  postBuild =
    let
      extraDeps = [
        "unenv-preset"
        "workers-utils"
        "local-explorer-ui"
        "codemod"
        "cli-shared-helpers"
        "miniflare"
        "wrangler"
      ];
    in
    ''
      mv packages/vitest-pool-workers packages/~vitest-pool-workers

      for pkg in ${toString extraDeps}; do
        NODE_ENV="production" pnpm --filter "$pkg" run build
      done
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    pnpm config set --location=project injectWorkspacePackages true
    pnpm --filter=wrangler --prod deploy $out/lib
    makeWrapper ${lib.getExe nodejs} $out/bin/wrangler \
      --inherit-argv0 \
      --set "NODE_PATH" $out/lib/node_modules \
      --add-flags $out/lib/bin/wrangler.js \
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" # https://github.com/cloudflare/workers-sdk/issues/3264
    runHook postInstall
  '';
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  preFixup = ''
    # fixupPhase spends a lot of time trying to strip text files, which is especially slow on Darwin
    stripExclude+=("*.js" "*.ts" "*.map" "*.json" "*.md")
  '';

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = with lib.licenses; [
      mit
      apsl20
    ];
    maintainers = with lib.maintainers; [
      seanrmurphy
      dezren39
      ryand56
      ezrizhu
      yuannan
    ];
    mainProgram = "wrangler";
    # Tunneling and other parts of wrangler, which require workerd won't run on
    # other systems where precompiled binaries are not provided, but most
    # commands are will still work everywhere.
    # Potential improvements: build workerd from source instead.
    inherit (nodejs.meta) platforms;
  };
})
