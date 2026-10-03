{
  lib,
  fetchurl,
  buildGoModule,
  fetchFromGitHub,

  webUI ? true,
}:
let
  version = "2.60.1";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "znserver";
    tag = "v${version}";
    hash = "sha256-jvztjDczsZYvyr5eSWGZdyU8Ihh4X9lhKlair9scCeE=";
  };

  # Download archive with webui
  webArchive = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/web-2.60.4-web.ha0258ecc7b3c0133/zennotes-self-hosted-web-2.60.4-web.ha0258ecc7b3c0133.tgz";
    sha256 = "11b9702b184feaa099b15c6488acfaa6b20095309ce590585ae7ae9eb0dd6a77";
  };
in
buildGoModule (finalAttrs: {
  pname = "zennotes-server";
  inherit version src;

  subPackages = [ "cmd/zennotes-server" ];

  __structuredAttrs = true;

  vendorHash = "sha256-ZdOHC2JldvnKSDUFnBUJrKD4F1IWfvYJBksgeDnU9cw=";

  postConfigure =
    if webUI then
      ''
        go run ./cmd/prepare-web \
        -manifest ${src}/web-artifact/manifest.json \
        -archive ${webArchive} -output web/dist

        go test -tags=embed_web ./web
      ''
    else
      "";

  ldflags = [
    "-s"
    "-w"
  ];

  tags = lib.optionals webUI [ "embed_web" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A server API for hosting remote ZenNotes vaults";
    homepage = "https://zennotes.org/";
    changelog = "https://github.com/ZenNotes/znserver/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      showhyt
    ];
    mainProgram = "zennotes-server";
    platforms = platforms.unix;
  };
})
