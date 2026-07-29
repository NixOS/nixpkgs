{
  lib,
  fetchurl,
  buildGoModule,
  fetchFromGitHub,

  # Tests
  curl,
  jq,
  runCommand,

  webUI ? true,
}:
let
  version = "2.75.0";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "znserver";
    tag = "v${version}";
    hash = "sha256-3RvUALj1wGRNTfpW9Z/CHJv3zj0yqNaG/IRTp1vl6FU=";
  };

  # Download archive with webui
  webArchive = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/web-2.75.0-web.h601ed1d04a616d4e/zennotes-self-hosted-web-2.75.0-web.h601ed1d04a616d4e.tgz";
    hash = "sha256-XI92Inm6oa0F6wAb1GPDS2q9sah7bSDNTjfy3te9vXk=";
  };

in
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  inherit version src;
  pname = "zennotes-server";

  subPackages = [ "cmd/zennotes-server" ];

  vendorHash = "sha256-ZdOHC2JldvnKSDUFnBUJrKD4F1IWfvYJBksgeDnU9cw=";

  postConfigure = lib.optionalString webUI ''
    go run ./cmd/prepare-web \
    -manifest ${src}/web-artifact/manifest.json \
    -archive ${webArchive} -output web/dist

    go test -tags=embed_web ./web
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  tags = lib.optionals webUI [ "embed_web" ];

  passthru = {
    updateScript = ./update.sh;
    tests.startup-check =
      runCommand "startup-check"
        {
          nativeBuildInputs = [
            curl
            jq
          ];
        }
        ''
          set -euo pipefail

          export ZENNOTES_VAULT_PATH=/tmp/ZenNotesVault
          ${finalAttrs.finalPackage}/bin/zennotes-server &
          sleep 1
          version="$(curl -sf -retry 10 http://127.0.0.1:7878/api/version | jq -r .version)"
          [ "$version" = "${finalAttrs.version}" ]
          sleep 1
          kill %1
          echo $version > $out
        '';
  };

  meta = {
    changelog = "https://github.com/ZenNotes/znserver/releases/tag/${finalAttrs.src.tag}";
    description = "A server API for hosting remote ZenNotes vaults";
    homepage = "https://zennotes.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      showhyt
    ];
    mainProgram = "zennotes-server";
    platforms = lib.platforms.unix;
  };
})
