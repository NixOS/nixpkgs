{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XdBIDSiBJVpiQgpQXI0qIbaqFVswxEoXGze2Nxes3lg=";
  };

  vendorHash = "sha256-z+m5ez17yF+GcUHyKU6a3Q69A6ACBVk0gCjKIaIJ554=";

  doCheck = false; # Require access to online S3 services

  ldFlags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Versity S3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "versitygw";
  };
})
