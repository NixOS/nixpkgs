{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  idna,
  pytestCheckHook,
  hypothesis,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "jmap-email";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "messages";
    tag = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-vgctyIDTsxrBMwiTFduyX0W+K2Y7cHODsvub5dovld4=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/jmap-email";

  build-system = [
    hatchling
  ];

  dependencies = [
    idna
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "jmap_email"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^${finalAttrs.pname}-(.*)" ];
  };

  meta = {
    description = "Strict-JMAP RFC 8621 Email object library for Python";
    homepage = "https://github.com/suitenumerique/messages";
    changelog = "https://github.com/suitenumerique/messages/blob/${finalAttrs.src.tag}/src/jmap-email/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
})
