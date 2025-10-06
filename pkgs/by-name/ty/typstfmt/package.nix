{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typstfmt";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = "typstfmt";
    rev = version;
    hash = "sha256-JsNaHeFYr92VdruE87dLj2kPGc9M+ww7AGiGO4Gbbr0=";
  };

  cargoHash = "sha256-sY2LLBsyRt7Zc84//WZWNq6e7Vx/TtPC/zoDF2Ug7yQ=";

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
