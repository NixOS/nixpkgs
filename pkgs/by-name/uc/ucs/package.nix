{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "ucs";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vmikk";
    repo = "ucs";
    tag = "${finalAttrs.version}";
    hash = "sha256-cw6hjEwY0f+B6Sqy3dITxebPDy22IOmr/zA/c0ZMK8o=";
  };

  vendorHash = "sha256-tH//UfQPcPf0Yo5wDINqzBxZG5A7nlGNSW/po9LLe2U=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "UC file summarizer";
    homepage = "https://github.com/vmikk/ucs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
