{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terraformer";
  version = "0.8.30";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "terraformer";
    rev = finalAttrs.version;
    sha256 = "sha256-xbZm0FOa/W6/qXMnJHuGgJhgu2NWtKrMoP0Ttd+hhdw=";
  };

  vendorHash = "sha256-TsJ8r0be38680sCP8ot3NKhW9ZT03eHrF/1UpYQuDWo=";

  subPackages = [ "." ];

  meta = {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    mainProgram = "terraformer";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ryan4yin ];
  };
})
