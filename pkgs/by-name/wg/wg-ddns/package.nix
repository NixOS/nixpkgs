{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wg-ddns";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "fernvenue";
    repo = "wg-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Djh/H/PlpwVeJ3T2V/xG8AAJNznYmStCQEMd5uh38us=";
  };

  vendorHash = "sha256-oJOpf7PPQvb5z7nqpW0YjOhsF0UiWt/nlwBvF2SdzsY=";

  meta = {
    description = "Lightweight tool that provides DDNS dynamic DNS support for WireGuard";
    homepage = "https://github.com/fernvenue/wg-ddns";
    license = lib.licenses.gpl3Only;
    maintainers = [
      lib.maintainers.fernvenue
      lib.maintainers.bdim404
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wg-ddns";
  };
})
