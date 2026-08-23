{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  click,
  rich,
  typing-extensions,

  # tests
  inline-snapshot,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rich-toolkit";
  version = "0.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick91";
    repo = "rich-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-XYSksCMCCxO6wzsEEJ6X340iT32hU5n/EikKLZ2m7A0=";
  };

  postPatch = ''
    # the commit updating the version happens only after tagging
    sed -i 's/version = ".*"/version = "${finalAttrs.version}"/' pyproject.toml
  '';

  build-system = [ hatchling ];

  dependencies = [
    click
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    inline-snapshot
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rich_toolkit" ];

  meta = {
    changelog = "https://github.com/patrick91/rich-toolkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Rich toolkit for building command-line applications";
    homepage = "https://github.com/patrick91/rich-toolkit/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
