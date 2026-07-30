{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vultr";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kyB6gUbc32NsSDqDy1zVT4HXn0pWxHdBOEBOSaI0Xro=";
  };

  vendorHash = null;

  # There are not test files
  doCheck = false;

  meta = {
    description = "CLI and API client library";
    mainProgram = "vultr";
    homepage = "https://jamesclonk.github.io/vultr";
    changelog = "https://github.com/JamesClonk/vultr/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zauberpony ];
  };
})
