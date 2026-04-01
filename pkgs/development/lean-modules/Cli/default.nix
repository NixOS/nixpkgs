{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-cli";
  version = "4.28.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4-cli";
    tag = "v4.28.0";
    hash = "sha256-9nX+dozmDAaVb5uKWL14zbILr7aqbVerTyPcN12Niw4=";
  };

  leanPackageName = "Cli";

  meta = {
    description = "Command-line argument parser for Lean 4";
    homepage = "https://github.com/leanprover/lean4-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
