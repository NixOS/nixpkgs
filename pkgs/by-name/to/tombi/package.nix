{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tombi";
  version = "0.4.42";

  src = fetchFromGitHub {
    owner = "tombi-toml";
    repo = "tombi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EOUi8yIXRJag9U2RzXWgX8vmOO7OJ/hmCpx7BvKsml4=";
  };

  # Tests relies on the presence of network
  doCheck = false;
  cargoBuildFlags = [ "--package tombi-cli" ];
  cargoHash = "sha256-Hwa+P0Qt3W171EzhuEdzY85w3XuHv6s4MCFkH4Ejqa8=";

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
