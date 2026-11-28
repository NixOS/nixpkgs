{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  click,
  hatch-vcs,
  hatchling,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "cloup";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "janluke";
    repo = "cloup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sXJvGVw6TZoZ/tnalRDPyX9WN9GJg6PdiRYYRJYVMOE=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ click ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    # tests/test_styling.py and tests/test_typing.py import it on every Python
    # version, not only below the 3.12 the package needs it for.
    typing-extensions
  ];

  pythonImportsCheck = [ "cloup" ];

  meta = {
    homepage = "https://github.com/janLuke/cloup";
    description = "Click extended with option groups, constraints, aliases, help themes";
    changelog = "https://github.com/janluke/cloup/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      Enriches Click with option groups, constraints, command aliases, help sections for
      subcommands, themes for --help and other stuff.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
