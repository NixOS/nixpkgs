{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  discordpy,
  click,
  braceexpand,
  import-expression,
  tabulate,
  pytestCheckHook,
  pytest-asyncio,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "jishaku";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Gorialis";
    repo = "jishaku";
    tag = finalAttrs.version;
    hash = "sha256-8kSdzrut7LYjglpHc5dToOIQTrPsW4lVAeIWY4rzdmU=";
  };

  postPatch = ''
    substituteInPlace jishaku/shell.py \
      --replace-fail '"/bin/bash"' '"${lib.getExe bash}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    discordpy
    click
    braceexpand
    tabulate
    import-expression
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "jishaku"
    "jishaku.repl"
    "jishaku.features"
  ];

  meta = {
    description = "Debugging and testing cog for discord.py bots";
    homepage = "https://jishaku.readthedocs.io/en/latest";
    changelog = "https://github.com/Gorialis/jishaku/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ ];
    mainProgram = "jishaku";
    license = lib.licenses.mit;
  };
})
