{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  beautifulsoup4,
  markdown,
  mdx-wikilink-plus,
  mkdocs,
  mkdocs-callouts,
  mkdocs-custom-tags-attributes,
  pymdown-extensions,
  python-frontmatter,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-embed-file-plugin";
  version = "2.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ObsidianPublisher";
    repo = "mkdocs-embed_file-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6FmMMaR+gyp5Gx0oXiDYvsr6uA8hwrV93YYrYkJsMNY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    markdown
    mdx-wikilink-plus
    mkdocs
    mkdocs-callouts
    mkdocs-custom-tags-attributes
    pymdown-extensions
    python-frontmatter
    ruamel-yaml
    setuptools
  ];

  pythonImportsCheck = [
    "mkdocs_embed_file_plugins"
  ];

  # No tests available.
  doCheck = false;

  meta = {
    description = "A way to embed a file present in your docs";
    homepage = "https://github.com/ObsidianPublisher/mkdocs-embed_file-plugin";
    changelog = "https://github.com/ObsidianPublisher/mkdocs-embed_file-plugin/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      agpl3Only
      agpl3Plus
    ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mkdocs-embed-file-plugin";
  };
})
