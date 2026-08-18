{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wishlist";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-RulCoXPqfsZrxlDMTbyFNxqf/tdi26Ikq6wNUXCp86I=";
  };

  vendorHash = "sha256-RPIxE1/ICchtCsIhShcJeUFfCWwzlCUfrY8yWfBeuHU=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Single entrypoint for multiple SSH endpoints";
    homepage = "https://github.com/charmbracelet/wishlist";
    changelog = "https://github.com/charmbracelet/wishlist/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caarlos0 ];
    mainProgram = "wishlist";
  };
})
