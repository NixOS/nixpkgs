{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "html-to-markdown";
  version = "3.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xberg-io";
    repo = "html-to-markdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JcOARqgZ6mXl51Geeo55WkNoNYhZBe2/tNrkY87xEXI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-yTup2ot3vxfLJ/TYKKKOraWClO6vt6vS1JPabdmGO7M=";
  };

  buildAndTestSubdir = "packages/python";

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  pythonImportsCheck = [
    "html_to_markdown"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf packages/python/html_to_markdown
  '';

  pytestFlags = [
    "packages/python/tests"
    "e2e/python/tests"
  ];

  disabledTests = [
    "test_visitor_honors_tagged_link_and_image_actions"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance HTML to Markdown converter powered by Rust with a clean Python API";
    homepage = "https://github.com/xberg-io/html-to-markdown";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
