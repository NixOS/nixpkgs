{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wayback-machine-archiver";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agude";
    repo = "wayback-machine-archiver";
    rev = "v${finalAttrs.version}";
    sha256 = "0dnnqx507gpj8wsx6f2ivfmha969ydayiqsvxh23p9qcixw9257x";
  };

  build-system = with python3.pkgs; [
    setuptools
    pypandoc
  ];

  dependencies = with python3.pkgs; [ requests ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \"pytest-runner\", ""
  '';

  pythonImportsCheck = [ "wayback_machine_archiver" ];

  meta = {
    description = "Python script to submit web pages to the Wayback Machine for archiving";
    homepage = "https://github.com/agude/wayback-machine-archiver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
    mainProgram = "archiver";
  };
})
