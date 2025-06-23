{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tombi";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "tombi-toml";
    repo = "tombi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2516aT6zaI5bntjjJ/p/yk0gWW6fzixQx5ESs29aS6Q=";
  };

  # Tests relies on the presence of network
  doCheck = false;
  cargoBuildFlags = [ "--package tombi-cli" ];
  cargoHash = "sha256-cVj0dL9vGVm3WPQ5IA2LDxDLHia5T+pLi6rTQxAqoC4=";

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0-dev"' 'version = "${finalAttrs.version}"'
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "TOML Formatter / Linter / Language Server";
    homepage = "https://github.com/tombi-toml/tombi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "tombi";
  };
})
