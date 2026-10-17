{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tylax";
  version = "0.3.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipenai";
    repo = "tylax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UWK7nnc2IVqr5T3I4K48qdvhUmOgR4ESJDGFs94w0sI=";
  };

  cargoHash = "sha256-ObOX8J6qYKMntO1wqJFZwiRa5fDSMXMO8svPAG0FFYM=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "High-performance bidirectional LaTeX and Typst converter";
    homepage = "https://github.com/scipenai/tylax";
    changelog = "https://github.com/scipenai/tylax/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "t2l";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.unix;
  };
})
