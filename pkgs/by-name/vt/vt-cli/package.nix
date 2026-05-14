{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vt-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-cli";
    tag = finalAttrs.version;
    hash = "sha256-B4SOoEc05nDFc93MYZDSj+LRt06jWjudocE4IKEw7jE=";
  };

  vendorHash = "sha256-n44nEff0/neaqHfU6UbPjEAW46axJ0hIxrOnlq5QKA0=";

  ldflags = [ "-X github.com/VirusTotal/vt-cli/cmd.Version=${finalAttrs.version}" ];

  subPackages = [ "vt" ];

  meta = {
    description = "VirusTotal Command Line Interface";
    homepage = "https://github.com/VirusTotal/vt-cli";
    changelog = "https://github.com/VirusTotal/vt-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "vt";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
