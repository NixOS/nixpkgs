{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wire";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "wire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pKWi5qRCSgWdGwEzoV0nx2t1HUODBaC6ELyf//+fPog=";
  };

  vendorHash = "sha256-pUzYfFrKV0M1j1P6DVIGCe6FaY+OPbn5VNLHP0Xu2R0=";

  subPackages = [ "cmd/wire" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/google/wire";
    description = "Code generation tool that automates connecting components using dependency injection";
    mainProgram = "wire";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ svrana ];
  };
})
