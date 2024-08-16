{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_9,
  autoPatchelfHook,
  cacert,
  llvmPackages,
  musl,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wrangler";
  version = "3.66.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "wrangler@${finalAttrs.version}";
    hash = "sha256-YY+wp9rmXDWeSvdMC6FQyuDf8XP3GhHeHuFe9q0uNng=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BjSpgkDYafnDb0SBdL3B6IYWT4EOqCAxdDm+Ev6QIgw=";
  };

  buildInputs = [
    llvmPackages.libcxx
    llvmPackages.libunwind
    musl
    xorg.libX11
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    nodejs
    pnpm_9.configHook
  ];

  # @cloudflare/vitest-pool-workers wanted to run a server as part of the build process
  # so I simply removed it
  postBuild = ''
    rm -fr packages/vitest-pool-workers
    NODE_ENV="production" pnpm --filter miniflare run build
    NODE_ENV="production" pnpm --filter wrangler run build
  '';

  # I'm sure this is suboptimal but it seems to work. Points:
  # - when build is run in the original repo, no specific executable seems to be generated; you run the resulting build with pnpm run start
  # - this means we need to add a dedicated script - perhaps it is possible to create this from the workers-sdk dir, but I don't know how to do this
  # - the build process builds a version of miniflare which is used by wrangler; for this reason, the miniflare package is copied also
  # - pnpm stores all content in the top-level node_modules directory, but it is linked to from a node_modules directory inside wrangler
  # - as they are linked via symlinks, the relative location of them on the filesystem should be maintained
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/lib/packages/wrangler
    rm -rf node_modules/typescript node_modules/eslint node_modules/prettier node_modules/bin node_modules/.bin node_modules/**/bin node_modules/**/.bin
    cp -r node_modules $out/lib
    cp -r packages/miniflare $out/lib/packages
    cp -r packages/workers-tsconfig $out/lib/packages
    cp -r packages/wrangler/node_modules $out/lib/packages/wrangler
    cp -r packages/wrangler/templates $out/lib/packages/wrangler
    cp -r packages/wrangler/wrangler-dist $out/lib/packages/wrangler
    rm -rf $out/lib/**/bin $out/lib/**/.bin
    cp -r packages/wrangler/bin $out/lib/packages/wrangler
    NODE_PATH_ARRAY=( "$out/lib/node_modules" "$out/lib/packages/wrangler/node_modules" )
    makeWrapper ${lib.getExe nodejs} $out/bin/wrangler \
      --inherit-argv0 \
      --prefix-each NODE_PATH : "$${NODE_PATH_ARRAY[@]}" \
      --add-flags $out/lib/packages/wrangler/bin/wrangler.js \
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" # https://github.com/cloudflare/workers-sdk/issues/3264
    runHook postInstall
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
    ];
    mainProgram = "wrangler";
    # cpp is required for building workerd.
    # workerd is used for some wrangler subcommands.
    # non-linux platforms may experience errors
    # on certain subcommands due to this issue.
    platforms = [ "x86_64-linux" ];
  };
})
