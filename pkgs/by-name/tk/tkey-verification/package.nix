{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "tkey-verification";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tillitis";
    repo = "tkey-verification";
    tag = "v${version}";
    hash = "sha256-WoV0AsMWMupRW+rJpsD28zGdASzeqQmIu9OGvFNcSW4=";
  };

  vendorHash = "sha256-ikCn68wh+46KCEAHjlt7ATrIcPyIpL/WwR0b0rfdWfY=";

  subPackages = [
    "cmd/tkey-verification"
  ];

  meta = {
    description = "Vendor signing and user verification of TKey genuineness";
    homepage = "https://tillitis.se/app/tkey-device-verification/";
    downloadPage = "https://github.com/tillitis/tkey-verification/releases";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ The1Penguin ];
    platforms = lib.platforms.all;
  };
}
