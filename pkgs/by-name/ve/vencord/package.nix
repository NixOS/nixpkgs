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
  fetchurl,
  stdenv,
  writeShellScript,
  buildWebExtension ? false,
}:
let
  # Credit to: @ScarsTRF (https://github.com/ScarsTRF/nixcord/blob/652dc8067b8004517ea43ebcc8d93a64f95d4327/vencord.nix#L28-L37)
  # Due to pnpm package 10.5.2 there is a issue when building.
  # Substituting pnpm with version 10.4.1 fixes this issue.
  # This should be fixed in a newer version of pnpm.
  pnpm_10-4 = pnpm.overrideAttrs (oldAttrs: {
    version = "10.4.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-10.4.1.tgz";
      sha256 = "sha256-S3Aoh5hplZM9QwCDawTW0CpDvHK1Lk9+k6TKYIuVkZc=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vencord";
  version = "1.11.6";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8KAt7yFGT/DBlg2VJ7ejsOJ67Sp5cuuaKEWK3+VpL4E=";
  };

  pnpmDeps = pnpm_10-4.fetchDeps {
    inherit (finalAttrs) pname src;
    hash = "sha256-g9BSVUKpn74D9eIDj/lS1Y6w/+AnhCw++st4s4REn+A=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm_10-4.configHook
  ];

  env = {
    ESBUILD_BINARY_PATH = lib.getExe (
      esbuild.overrideAttrs (
        final: _: {
          version = "0.25.0";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${final.version}";
            hash = "sha256-L9jm94Epb22hYsU3hoq1lZXb5aFVD4FC4x2qNt0DljA=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      )
    );
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

  meta = {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      donteatoreo
      FlafyDev
      NotAShelf
      Scrumplex
    ];
  };
})
