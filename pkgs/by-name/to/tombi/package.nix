{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tombi";
  version = "0.4.25";

  src = fetchFromGitHub {
    owner = "tombi-toml";
    repo = "tombi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EVr4qybyLtGgNde0uuNoQYv2jugNGJups5HUcs7n4KI=";
  };

  # Tests relies on the presence of network
  doCheck = false;
  cargoBuildFlags = [ "--package tombi-cli" ];
  cargoHash = "sha256-vtaif74fYBCP0AAL1NFXxHJ/casZGwTJsmwZLiWqY64=";

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
