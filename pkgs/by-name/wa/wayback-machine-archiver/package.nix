{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wayback-machine-archiver";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agude";
    repo = "wayback-machine-archiver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gowktQvJg09iD+6KhP/EpYXOGMXXWy4nAaxvEc2sh3o=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    requests
    python-dotenv
    urllib3
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "wayback_machine_archiver" ];

  meta = {
    description = "Python script to submit web pages to the Wayback Machine for archiving";
    homepage = "https://github.com/agude/wayback-machine-archiver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
    mainProgram = "archiver";
  };
})
