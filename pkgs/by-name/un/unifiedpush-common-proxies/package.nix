{
  lib,
  fetchFromCodeberg,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "unifiedpush-common-proxies";
  version = "3.1.0";

  src = fetchFromCodeberg {
    owner = "UnifiedPush";
    repo = "common-proxies";
    rev = finalAttrs.version;
    sha256 = "sha256-VRxwEsQt1LlcMIMEkGqkVtMrqJ7f4tYh3OExE9VITh4=";
  };

  vendorHash = "sha256-rGsSuO7cnb9e4A1SnIwfgfz4vu18JzxKtLnDfCSQqck=";

  meta = {
    description = "Set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimward ];
    mainProgram = "common-proxies";
  };
})
