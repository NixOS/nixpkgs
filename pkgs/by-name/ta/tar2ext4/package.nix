{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-/ImyicXRBGclnUEpqygNYhknFYJmRqBqKkz/gNxVLWQ=";
  };

  sourceRoot = "${src.name}/cmd/tar2ext4";
  vendorHash = null;

  meta = {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.mit;
    mainProgram = "tar2ext4";
  };
}
