{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yggstack";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggstack";
    rev = "${finalAttrs.version}";
    hash = "sha256-S3yk2v2RPGFeGDJ8Lmjr7VM2kIswIREfPpDLXM/P1YU=";
  };

  vendorHash = "sha256-7EIUsMhAJ+uPD5LG7Yucpo82aJYYRt9vrmAbsQzNmEw=";

  ldflags = [
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${finalAttrs.version}"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=yggstack"
    "-s"
    "-w"
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yggdrasil as SOCKS proxy / port forwarder";
    homepage = "https://yggdrasil-network.github.io/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [
      peigongdsd
    ];
  };
})
