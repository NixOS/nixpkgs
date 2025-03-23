{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  wcwidth,

  # tests
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ftfy";
  version = "6.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "rspeer";
    repo = "python-ftfy";
    tag = "v${version}";
    hash = "sha256-TmwDJeUDcF+uOB2X5tMmnf9liCI9rP6dYJVmJoaqszo=";
  };

  build-system = [ hatchling ];

  dependencies = [ wcwidth ];

  pythonImportsCheck = [ "ftfy" ];

  nativeCheckInputs = [
    versionCheckHook
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    changelog = "https://github.com/rspeer/python-ftfy/blob/${src.rev}/CHANGELOG.md";
    description = "Given Unicode text, make its representation consistent and possibly less broken";
    mainProgram = "ftfy";
    homepage = "https://github.com/LuminosoInsight/python-ftfy";
    license = licenses.asl20;
    maintainers = with maintainers; [ aborsu ];
  };
}
