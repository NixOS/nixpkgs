{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wayback-machine-archiver";
  version = "3.5.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agude";
    repo = "wayback-machine-archiver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LUWPc1wMSpBIdaje/pbmQYHTrYog/9UiphMY1fzxgPc=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    requests
    python-dotenv
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "wayback_machine_archiver" ];

  meta = {
    description = "Python script to submit web pages to the Wayback Machine for archiving";
    homepage = "https://github.com/agude/wayback-machine-archiver";
    changelog = "https://github.com/agude/wayback-machine-archiver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
    mainProgram = "archiver";
  };
})
