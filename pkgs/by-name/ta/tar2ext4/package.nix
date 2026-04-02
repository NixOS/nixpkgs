{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tar2ext4";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8FPEGQ6DBYYnT6mIjYmSTRfHMloS42oB8xPU5wmFLwI=";
  };

  sourceRoot = "${finalAttrs.src.name}/cmd/tar2ext4";
  vendorHash = null;

  meta = {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.mit;
    mainProgram = "tar2ext4";
  };
})
