{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  markdown,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdx-wikilink-plus";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neurobin";
    repo = "mdx_wikilink_plus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d0F0blSYYRNbkwnbL9kzkNbfNVG2NZV74WapP5ubkoo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    markdown
  ];

  pythonImportsCheck = [
    "mdx_wikilink_plus"
  ];

  # No tests available.
  doCheck = false;

  meta = {
    description = "A wikilink extension for Python Markdown";
    homepage = "https://github.com/neurobin/mdx_wikilink_plus";
    changelog = "https://github.com/neurobin/mdx_wikilink_plus/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mdx-wikilink-plus";
  };
})
