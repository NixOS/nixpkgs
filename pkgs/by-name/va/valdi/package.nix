{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "valdi";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "Snapchat";
    repo = "Valdi";
    rev = "592fc9d13065022fc7da1f0c07928f1764062074";
    hash = "sha256-B0j4R07M9/nTf0RxnKEfv84B5Xh41cWLz9VgV9O4+VA=";
  };

  sourceRoot = "${src.name}/npm_modules/cli";

  npmDepsHash = "sha256-LGgyMdhDQ4UwdtENZT/89yiQawn8SxKdth/p7evDAgk=";

  meta = {
    description = "Cross-platform UI framework CLI by Snapchat";
    homepage = "https://github.com/Snapchat/Valdi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonasfranke ];
    mainProgram = "valdi";
  };
}
