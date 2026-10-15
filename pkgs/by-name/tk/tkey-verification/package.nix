{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "tkey-verification";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tillitis";
    repo = "tkey-verification";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WoV0AsMWMupRW+rJpsD28zGdASzeqQmIu9OGvFNcSW4=";
  };

  vendorHash = "sha256-ikCn68wh+46KCEAHjlt7ATrIcPyIpL/WwR0b0rfdWfY=";

  subPackages = [
    "cmd/tkey-verification"
  ];

  ldflags = [
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Vendor signing and user verification of TKey genuineness";
    homepage = "https://tillitis.se/app/tkey-device-verification/";
    downloadPage = "https://github.com/tillitis/tkey-verification/releases";
    license = [
      lib.licenses.bsd2
      # GPL2Only binaries
      lib.licenses.gpl2Only
    ];
    changelog = "https://github.com/tillitis/tkey-verification/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ lib.maintainers.akechishiro ];
    platforms = lib.platforms.all;
  };
})
