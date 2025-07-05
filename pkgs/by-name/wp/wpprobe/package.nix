{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "wpprobe";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Chocapikk";
    repo = "wpprobe";
    tag = "v${version}";
    hash = "sha256-hx09+GZ14Gho09wZCMTSmfJiT/DOJKNVNCA1++RVDhI=";
  };

  vendorHash = "sha256-KV6Ss0fN3xwm5Id7MAHMUjq9TsQbaInLjd5xcLKGX6U=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Chocapikk/wpprobe/internal/utils.Version=v${version}"
  ];

  checkFlags = [
    # Test requires network access
    "-skip=TestUpdateWordfence"
  ];

  meta = {
    description = "WordPress plugin enumeration tool";
    homepage = "https://github.com/Chocapikk/wpprobe";
    changelog = "https://github.com/Chocapikk/wpprobe/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wpprobe";
  };
}
