{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "varunastra";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "redhuntlabs";
    repo = "Varunastra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nyvTbfKEwUwHwuKSRaABigM6eG6LFGd9HwGpATUg/5E=";
  };

  vendorHash = "sha256-gt33THFCJWTqnhX1+O0WZJH2sbskM/NEZru7QUDFgQs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to enhance the security of Docker environments";
    homepage = "https://github.com/redhuntlabs/Varunastra";
    changelog = "https://github.com/redhuntlabs/Varunastra/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "varunastra";
  };
})
