{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trojan-go";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "p4gefau1t";
    repo = "trojan-go";
    tag = "v${version}";
    hash = "sha256-ZzIEKyLhHwYEWBfi6fHlCbkEImetEaRewbsHQEduB5Y=";
  };

  vendorHash = "sha256-c6H/8/dmCWasFKVR15U/kty4AzQAqmiL/VLKrPtH+s4=";

  doCheck = false;

  meta = {
    homepage = "https://p4gefau1t.github.io/trojan-go/";
    description = "Proxy mechanism to bypass GFW";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.gpl3Only;
    mainProgram = "trojan-go";
  };
}
