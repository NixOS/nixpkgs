{
  lib,
  fetchurl,
  buildGoModule,
  fetchFromGitHub,

  webUI ? true,
}:
let
  version = "2.60.0";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "znserver";
    tag = "v${version}";
    hash = "sha256-Q83wloWu/H1tfWVxwWdjUN+2dQI41/t+h8agoBDG8a0=";
  };

  # Download archive with webui
  webArchive = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/web-2.60.0-web.h5a4dd1242cf8c2c0/zennotes-self-hosted-web-2.60.0-web.h5a4dd1242cf8c2c0.tgz";
    sha256 = "c34e81c32c46709a225332e1f19fc10135566fecb85088e844f361dfb31d8084";
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
