{
  curl,
  fetchFromGitHub,
  git,
  jq,
  lib,
  nix-update,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,
  writeShellScript,
  discord,
  discord-ptb,
  discord-canary,
  discord-development,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vencord";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g+zyq4KvLhn1aeziTwh3xSYvzzB8FwoxxR13mbivyh4=";
  };

  patches = [ ./fix-deps.patch ];

  postPatch = ''
    substituteInPlace packages/vencord-types/package.json \
      --replace-fail '"@types/react": "18.3.1"' '"@types/react": "19.0.12"'
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      src
      patches
      postPatch
      ;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-K9rjPsODn56kM2k5KZHxY99n8fKvWbRbxuxFpYVXYks=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  env = {
    VENCORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    VENCORD_HASH = "${finalAttrs.version}";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run ${if buildWebExtension then "buildWeb" else "build"} \
      -- --standalone --disable-updater

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/${lib.optionalString buildWebExtension "chromium-unpacked/"} $out
    cp package.json $out # Presence is checked by Vesktop.

    runHook postInstall
  '';

  passthru = {
    # We need to fetch the latest *tag* ourselves, as nix-update can only fetch the latest *releases* from GitHub
    # Vencord had a single "devbuild" release that we do not care about
    updateScript = writeShellScript "update-vencord" ''
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          nix-update
        ]
      }:$PATH"
      ghTags=$(curl ''${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/Vendicated/Vencord/tags")
      latestTag=$(echo "$ghTags" | jq -r .[0].name)

      echo "Latest tag: $latestTag"

      exec nix-update --version "$latestTag" "$@"
    '';

    tests = lib.genAttrs' [ discord discord-ptb discord-canary discord-development ] (
      p: lib.nameValuePair p.pname p.tests.withVencord
    );
  };

  meta = {
    description = "Cutest Discord client mod";
    homepage = "https://github.com/Vendicated/Vencord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      FlameFlag
      FlafyDev
      Gliczy
      NotAShelf
      Scrumplex
      ryand56
    ];
  };
})
