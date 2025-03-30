{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstfmt";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = version;
    hash = "sha256-bSjUr6tHQrmni/YmApHrvY2cVz3xf1VKfg35BJjuOZM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-C3kVmQcG2a4eg8bu36lTy2dDQcw2uX/iS6Wco6ambdE=";

  meta = {
    changelog = "https://github.com/astrale-sharp/typstfmt/blob/${src.rev}/CHANGELOG.md";
    description = "Formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typstfmt";
    license = lib.licenses.mit;
    mainProgram = "typstfmt";
    maintainers = with lib.maintainers; [
      figsoda
      geri1701
    ];
  };
}
