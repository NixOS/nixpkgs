{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  uv-build,

  # dependencies
  pyyaml,

  # tests
  pytestCheckHook,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-frontmatter";
  version = "1.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eyeseast";
    repo = "python-frontmatter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b/ruWPPiKvDzMjcVhxiBtnAaMNWnWvy1v8GZxGeibyY=";
  };

  build-system = [ uv-build ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [
    pytestCheckHook
    toml
  ];

  pytestFlags = [
    "--doctest-glob=README.md"
    "--doctest-modules"
  ];

  pythonImportsCheck = [ "frontmatter" ];

  meta = {
    description = "Parse and manage posts with YAML (or other) frontmatter";
    homepage = "https://github.com/eyeseast/python-frontmatter";
    changelog = "https://github.com/eyeseast/python-frontmatter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
