{
  curl,
  esbuild,
  fetchFromGitHub,
  git,
  jq,
  lib,
  nix-update,
  nodejs,
  pnpm,
  stdenv,
  writeShellScript,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vencord";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rLdUEdAvYy8SDgKWUanZgmMnJ6Dg2dO5tTpGTwlQCrU=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src;

    hash = "sha256-bosCE9gBFCcM3Ww6sJmhps/cl4lovXKMieYpkqAMst8=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm.configHook
  ];

  env = {
    ESBUILD_BINARY_PATH = lib.getExe (
      esbuild.overrideAttrs (
        final: _: {
          version = "0.15.18";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${final.version}";
            hash = "sha256-b9R1ML+pgRg9j2yrkQmBulPuLHYLUQvW+WTyR/Cq6zE=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      )
    );
    VENCORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    # TODO: somehow update this automatically
    VENCORD_HASH = "deadbeef";
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

    runHook postInstall
  '';

  # We need to fetch the latest *tag* ourselves, as nix-update can only fetch the latest *releases* from GitHub
  # Vencord had a single "devbuild" release that we do not care about
  passthru.updateScript = writeShellScript "update-vencord" ''
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

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      FlafyDev
      NotAShelf
      Scrumplex
    ];
  };
})
