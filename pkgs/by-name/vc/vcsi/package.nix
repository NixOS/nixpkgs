{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "vcsi";
  version = "7.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amietn";
    repo = "vcsi";
    tag = "v${version}";
    hash = "sha256-I0o6GX/TNMfU+rQtSqReblRplXPynPF6m2zg0YokmtI=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "numpy"
    "pillow"
  ];

  dependencies = with python3Packages; [
    jinja2
    numpy
    parsedatetime
    pillow
    texttable
  ];

  pythonImportsCheck = [ "vcsi" ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
  ]);
  versionCheckProgramArg = "--version";

  meta = {
    description = "Create video contact sheets";
    homepage = "https://github.com/amietn/vcsi";
    changelog = "https://github.com/amietn/vcsi/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dandellion
      zopieux
    ];
    mainProgram = "vcsi";
  };
}
