{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  nix-update-script,

  # build dependencies
  poetry-core,

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

buildPythonPackage rec {
  pname = "cleanit";
  version = "0.4.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "cleanit";
    tag = version;
    hash = "sha256-5fzBcOr6PGp847S7qLsXgYKxPcGW4mM5B5QNBSvH7BM=";
  };

  build-system = [ poetry-core ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool that helps you to keep your subtitles clean";
    homepage = "https://github.com/ratoaq2/cleanit";
    changelog = "https://github.com/ratoaq2/cleanit/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "cleanit";
  };
}
