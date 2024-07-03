{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
}:
let
  srcHash = "sha256-/4iIkvSn85fkRggmIha2kRlW0MEwvzy0ZAmIb8+LpZQ=";
  pnpmDepsHash = "sha256-aTTaiGXm1WYwmy+ljUC9yO3qtvN20SA+24T83dWYrI0=";
in
  stdenv.mkDerivation (finalAttrs: {
  pname = "wrangler";
  version = "3.62.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "wrangler@${finalAttrs.version}";
    hash = "${srcHash}";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "${pnpmDepsHash}";
  };

  # @cloudflare/vitest-pool-workers wanted to run a server as part of the build process
  # so I simply removed it
  postBuild = ''
    rm -fr packages/vitest-pool-workers
    NODE_ENV="production" pnpm run build
    # pnpm --offline deploy --frozen-lockfile  --ignore-script  --filter=bash-language-server server-deploy
  '';

  # this was taken from a previous script which was generated somehow
  wranglerScript = pkgs.writeText "wrangler" ''
        #!/bin/sh
        basedir=$(dirname "$(echo "$0" | sed -e 's,\\,/,g')")

        case `uname` in
            *CYGWIN*) basedir=`cygpath -w "$basedir"`;;
        esac

        if [ -z "$NODE_PATH" ]; then
          export NODE_PATH="WRANGLER_PATH/lib/node_modules:WRANGLER_PATH/lib/packages/wrangler/node_modules"
        else
          export NODE_PATH="WRANGLER_PATH/lib/node_modules:WRANGLER_PATH/lib/packages/wrangler/node_modules:$NODE_PATH"
        fi
        if [ -x "$basedir/node" ]; then
          exec "$basedir/node"  "WRANGLER_PATH/lib/packages/wrangler/bin/wrangler.js" "$@"
        else
          exec node  "WRANGLER_PATH/lib/packages/wrangler/bin/wrangler.js" "$@"
        fi
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
    rm -rf node_modules/typescript node_modules/eslint node_modules/.bin/eslint node_modules/prettier node_modules/.bin/prettier
    cp -r node_modules $out/lib
    cp -r packages/wrangler/bin $out/lib/packages/wrangler
    cp -r packages/wrangler/wrangler-dist $out/lib/packages/wrangler
    cp -r packages/wrangler/node_modules $out/lib/packages/wrangler
    cp -r packages/miniflare $out/lib/packages/
    cp $wranglerScript $out/bin/wrangler
    chmod a+x $out/bin/wrangler
    substituteInPlace $out/bin/wrangler --replace-warn /bin/sh ${pkgs.bash}/bin/sh
    substituteInPlace $out/bin/wrangler --replace-warn WRANGLER_PATH $out
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = "MIT OR Apache-2.0";
    maintainers = with lib.maintainers; [ seanrmurphy dezren39 ];
    mainProgram = "wrangler";
  };
})
