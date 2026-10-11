{
  lib,
  fetchurl,
  buildGoModule,
  fetchFromGitHub,

  webUI ? true,
}:
let
  version = "2.66.0";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "znserver";
    tag = "v${version}";
    hash = "sha256-KRfiP1LGDIQv+V3f/eIOLsxm0taKoQlAdA6xYaPfN6I=";
  };

  # Download archive with webui
  webArchive = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/web-2.66.0-web.hcd0a82b505c8cc0f/zennotes-self-hosted-web-2.66.0-web.hcd0a82b505c8cc0f.tgz";
    sha256 = "38ff6ee2d74642b915a50e07ccbaef78a6031fb4ea7283d7b04731480b144646";
  };
in
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  inherit version src;
  pname = "zennotes-server";

  subPackages = [ "cmd/zennotes-server" ];

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

  passthru.updateScript = ./update.sh;
})
