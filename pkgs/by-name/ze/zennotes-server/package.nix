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
  version = "2.70.0";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "znserver";
    tag = "v${version}";
    hash = "sha256-T7Nq36jQqKTSZ1Rn666YUaNo8wq1nSAJ92jZ4l2SzE8=";
  };

  # Download archive with webui
  webArchive = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/web-2.70.0-web.h661b8da927ac7586/zennotes-self-hosted-web-2.70.0-web.h661b8da927ac7586.tgz";
    hash = "sha256-llfvj/DLzipqCIfP6d3L917J9VfGn+xutC5VAM44Eu0=";
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
    changelog = "https://github.com/ZenNotes/znserver/releases/tag/v${finalAttrs.version}";
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
