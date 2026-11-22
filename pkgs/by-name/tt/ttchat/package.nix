{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ttchat";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "atye";
    repo = "ttchat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JQprOoC/+FlKOBlBAjKTU7vwNSIz6bE4euw7fHxbIAU=";
  };

  vendorHash = "sha256-0/VmQahglmGgdmCR/iRMM3S0cSMt4LLgN1zU9/IWZDA=";

  meta = {
    description = "Connect to a Twitch channel's chat from your terminal";
    homepage = "https://github.com/atye/ttchat";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "ttchat";
  };
})
