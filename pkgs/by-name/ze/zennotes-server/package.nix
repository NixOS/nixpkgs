{
  lib,
  fetchurl,
  buildGoModule,
  fetchFromGitHub,

  webUI ? true,
}:
let
  version = "2.56.0";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "znserver";
    tag = "v${version}";
    hash = "sha256-Aurp+p7pATH0K4olEKRjjk9Ty64HChE1tEnCMXCGRpw=";
  };

  # Download archive with webui
  webArchive = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/web-2.56.0-web.h377717cfb31ad477/zennotes-self-hosted-web-2.56.0-web.h377717cfb31ad477.tgz";
    sha256 = "ace2c0bd33bf336878a6064473f9c3f54df1557e65a983ca9c7dbffdfc2b2c24";
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
