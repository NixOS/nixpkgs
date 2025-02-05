{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "2.5.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjpost";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ErssNc8X376E26maGJo/P19CA7FDxZ4/h6mgRB+YNZc=";
  };

  # postPatch = ''
  #   substituteInPlace setup.py \
  #     --replace "portalocker==" "portalocker>="
  # '';

  propagatedBuildInputs = [
    portalocker
    regex
    tabulate
    numpy
    colorama
    lxml
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # require network access
    "test/test_api.py"
    "test/test_dataset.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "sacrebleu" ];

  meta = with lib; {
    description = "Hassle-free computation of shareable, comparable, and reproducible BLEU, chrF, and TER scores";
    mainProgram = "sacrebleu";
    homepage = "https://github.com/mjpost/sacrebleu";
    changelog = "https://github.com/mjpost/sacrebleu/blob/v{version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
