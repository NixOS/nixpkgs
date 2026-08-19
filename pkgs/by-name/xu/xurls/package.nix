{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "go-1.26.patch";
      url = "https://github.com/mvdan/xurls/commit/6fcda1fd6decab4a6bc49ced3b36d666cc57b7cf.patch";
      hash = "sha256-5X2mK9Xfjmu1kaZPeut4RE3r4ku6jRDwidtzRpF5Qis=";
    })
  ];

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
