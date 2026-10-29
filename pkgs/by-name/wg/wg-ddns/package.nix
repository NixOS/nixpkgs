{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wg-ddns";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "fernvenue";
    repo = "wg-ddns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BV57jidn6bPWU/IhhQvIeMF4xHtTm2WZKm4MQRSMM5Y=";
  };

  vendorHash = "sha256-VfSLrWuvJF4XwAW2BQGxh+3v9RiWmPdysw/nIdt2A9M=";

  meta = {
    description = "Lightweight tool that provides DDNS dynamic DNS support for WireGuard";
    homepage = "https://github.com/fernvenue/wg-ddns";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.bdim404 ];
    platforms = lib.platforms.unix;
    mainProgram = "wg-ddns";
  };
})
