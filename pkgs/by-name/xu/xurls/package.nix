{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xurls";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cfiMrJuzm5wpVKSyhta4ovARbp5B6K30l3+I/KOsZM4=";
  };

  vendorHash = "sha256-Bks47kusGgVsbNiLq3QxP/dhIp72HGYeMhdifFwY340=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Extract urls from text";
    homepage = "https://github.com/mvdan/xurls";
    mainProgram = "xurls";
    maintainers = with lib.maintainers; [ koral ];
    license = lib.licenses.bsd3;
  };
})
