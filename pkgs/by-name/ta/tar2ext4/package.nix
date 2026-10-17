{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tar2ext4";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Jl0Iiojc4Z20MQKKkjKDC3b6ZR6JXGfTWro9EWNXWjY=";
  };

  sourceRoot = "${finalAttrs.src.name}/cmd/tar2ext4";
  vendorHash = null;

  meta = {
    description = "Convert a tar archive to an ext4 image";
    homepage = "https://github.com/microsoft/hcsshim";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.mit;
    mainProgram = "tar2ext4";
  };
})
