{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build dependencies
  hatchling,

  # dependencies
  appdirs,
  babelfish,
  chardet,
  click,
  jsonschema,
  pysrt,
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cleanit";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "cleanit";
    tag = finalAttrs.version;
    hash = "sha256-3jhiEUgugCYTykr0nwyyM+S9puqIZYuaPZ9H9BF3vFg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    appdirs
    babelfish
    chardet
    click
    jsonschema
    pysrt
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cleanit" ];

  meta = {
    description = "Command line tool that helps you to keep your subtitles clean";
    homepage = "https://github.com/ratoaq2/cleanit";
    changelog = "https://github.com/ratoaq2/cleanit/blob/${finalAttrs.src.rev}/HISTORY.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "cleanit";
  };
})
