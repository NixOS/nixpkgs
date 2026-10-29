{
  dart-sass,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nixosTests,
  nodejs_26,
  postgresql,
  stdenv,
  yarn-berry_4,
}:
let
  nodejs = nodejs_26;
  yarn-berry = yarn-berry_4.override { inherit nodejs; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "twenty";
  version = "2.53.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "twentyhq";
    repo = "twenty";
    tag = "twenty/v${finalAttrs.version}";
    hash = "sha256-oKb5Ax0/fRicXcceEJPOp8EM6ZLxWL6qJS/A6AMleF8=";
  };

  postPatch = ''
    # Remove the configured `yarnPath` so we use the version of `yarn` from nixpkgs, rather than the version
    # vendored in the project. Unfortunately, YARN_IGNORE_PATH doesn't
    # propagate down to scripts that themselves invoke `yarn` (`yarn database:init` invokes `yarn database:migrate:prod`).
    # Reported in <https://github.com/yarnpkg/berry/issues/7309>.
    substituteInPlace .yarnrc.yml --replace-fail "yarnPath: " "# yarnPath"

    # yarn-ignore-path.patch ensures we use `yarn` from nixpkgs rather than the
    # version vendored in the project. Removing the embedded yarn makes any mistakes
    # fail fast rather than falling back to the embedded yarn.
    rm -r .yarn/releases/
  '';

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    makeWrapper
  ];

  passthru = {
    # Blocked on:
    # - Unreleased change to nix-update: <https://github.com/Mic92/nix-update/pull/640#issuecomment-6298951201>
    # - Unmerged fix to yarn-berry-fetcher: <https://cyberchaos.dev/yuka/yarn-berry-fetcher/-/merge_requests/29>
    # updateScript = nix-update-script { };

    tests = { inherit (nixosTests) twenty; };
  };

  # To generate this file:
  # nix-shell -p yarn-berry_4.yarn-berry-fetcher --command 'yarn-berry-fetcher missing-hashes "$(nix-build -A twenty.src)/yarn.lock" > pkgs/by-name/tw/twenty/missing-hashes.json'
  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-G6XP/ByEDQ+6fBEEbAgVx8DWvhxqfanW02p9xIRnako=";
  };

  preBuild = ''
    # Force sass-embedded npm package to use our dart-sass instead of bundled binaries.
    # https://github.com/sass/embedded-host-node/issues/334
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  buildPhase = ''
    runHook preBuild

    function nx() {
      # `nx` crashes if stdout is a TTY but it has no controlling terminal:
      # <https://github.com/nrwl/nx/issues/37447>.
      # This is exactly the environment the nix build sandbox creates.
      # A simple workaround is to ensure that stdout is not a TTY,
      # which we can do by piping to `cat.`
      npx nx "$@" | cat
    }

    # Build the backend server (this produces ./packages/twenty-server/dist/).
    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L48-L53
    nx run twenty-server:lingui:extract
    nx run twenty-server:lingui:compile
    nx run twenty-emails:lingui:extract
    nx run twenty-emails:lingui:compile
    nx run twenty-server:build

    # Build the frontend (this produces ./packages/twenty-front/build/).
    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L71-L80
    nx run twenty-front:lingui:extract
    nx run twenty-front:lingui:compile
    nx build twenty-front

    # Move the frontend to where the backend can serve it up.
    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L187
    mv ./packages/twenty-front/build ./packages/twenty-server/dist/front

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L38
    yarn workspaces focus twenty-monorepo twenty-server twenty-emails twenty-shared twenty-client-sdk

    mkdir -p $out/bin $out/share/twenty

    # Workspace root config
    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L111-L115
    mv package.json yarn.lock .yarnrc.yml $out/share/twenty
    mv tsconfig.base.json nx.json $out/share/twenty
    rm -r .yarn/cache && mv .yarn $out/share/twenty
    mv node_modules $out/share/twenty

    mv ./packages/twenty-docker/twenty/entrypoint.sh $out/bin/entrypoint.sh

    # Copy only the packages we need, and avoid copying a bunch of files in those
    # packages we don't need. Patterned off of
    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L117-L133
    # Added twenty-oxlint-rules because otherwise it ends up as a broken symlink
    # in `node_modules`, which `noBrokenSymlinks` complains about.
    twenty_packages=$out/share/twenty/packages
    mkdir -p $twenty_packages
    for package in twenty-server twenty-shared twenty-emails twenty-client-sdk twenty-oxlint-rules; do
      mkdir -p $twenty_packages/$package
      mv ./packages/$package/{package.json,dist} $twenty_packages/$package
    done
    # A few extra things needed by the twenty-server package. (See Dockerfile linked above.)
    mv ./packages/twenty-server/{patches,scripts} $twenty_packages/twenty-server

    wrapProgram $out/bin/entrypoint.sh \
      --set NODE_ENV production \
      --set APP_VERSION ${finalAttrs.version} \
      --set NODE_PATH $out/share/twenty/node_modules \
      --prefix PATH : ${
        lib.makeBinPath [
          postgresql
          yarn-berry
        ]
      }

    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/twenty/Dockerfile#L164-L165
    makeWrapper $out/bin/entrypoint.sh $out/bin/twenty-server \
      --chdir $out/share/twenty/packages/twenty-server \
      --add-flags "${lib.getExe nodejs} $twenty_packages/twenty-server/dist/main"

    # https://github.com/twentyhq/twenty/blob/twenty/v2.45.0/packages/twenty-docker/docker-compose.yml#L66
    makeWrapper $out/bin/entrypoint.sh $out/bin/twenty-worker \
      --chdir $out/share/twenty/packages/twenty-server \
      --add-flags "yarn worker:prod"

    runHook postInstall
  '';

  # Disable hardened mode. We cannot use it in the nix build sandbox as it
  # needs internet access to talk to remote registries during `yarn install`:
  # <https://yarnpkg.com/configuration/yarnrc#enableHardenedMode>
  env.YARN_ENABLE_HARDENED_MODE = "false";

  meta = {
    changelog = "https://github.com/twentyhq/twenty/releases/tag/${finalAttrs.src.tag}";
    description = "The open alternative to Salesforce, designed for AI";
    homepage = "https://twenty.com";

    # From <https://twenty.com/terms>:
    #
    # > Twenty’s source code is publicly available at <github.com/twentyhq/twenty> and
    # > is licensed mostly under the GNU Affero General Public License v3 (AGPLv3),
    # > with certain packages under the MIT license and certain files under a commercial
    # > license, as described in the LICENSE file of the repository.
    #
    # Unfree license ("The Twenty.com Commercial License") only
    # applies if you buy and use a license key:
    #
    # > If you self-host the free edition of Twenty, your use of the
    # > software is governed by its open-source licenses, not by
    # > these Terms; only your use of the Site and of any services
    # > we provide to you (such as license keys or support) is covered here.
    license =
      with lib.licenses;
      AND [
        lib.licenses.agpl3Only
        lib.licenses.mit
      ];

    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
  };
})
