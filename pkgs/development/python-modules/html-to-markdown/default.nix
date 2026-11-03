{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "html-to-markdown";
  version = "3.23.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xberg-io";
    repo = "html-to-markdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8dSnsIOZMQEOEjSL9hGgjWjjB9zOuF9PsDPjl+DnJxg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-aVVNvGJJSR946/pOrG7TJAuHpUjjug2Dh3R6N20jS/8=";
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

  meta = {
    description = "High-performance HTML to Markdown converter powered by Rust with a clean Python API";
    homepage = "https://github.com/xberg-io/html-to-markdown";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
