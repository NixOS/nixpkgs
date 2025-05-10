{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # Propagated build inputs
  portalocker,
  regex,
  tabulate,
  numpy,
  colorama,
  lxml,

  # Check inputs
  pytestCheckHook,
}:
let
  pname = "sacrebleu";
  version = "2.5.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjpost";
    repo = "sacrebleu";
    tag = "v${version}";
    hash = "sha256-nLZotWQLrN9hB1fBuDJkvGr4SMvQz8Ucl8ybpNhf9Ic=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    portalocker
    regex
    tabulate
    numpy
    colorama
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # require network access
    "test/test_api.py"
    "test/test_dataset.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "sacrebleu" ];

  meta = {
    description = "Hassle-free computation of shareable, comparable, and reproducible BLEU, chrF, and TER scores";
    mainProgram = "sacrebleu";
    homepage = "https://github.com/mjpost/sacrebleu";
    changelog = "https://github.com/mjpost/sacrebleu/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
