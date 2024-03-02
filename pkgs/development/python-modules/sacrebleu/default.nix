{ lib
, buildPythonPackage
, fetchFromGitHub

# Propagated build inputs
, portalocker
, regex
, tabulate
, numpy
, colorama
, lxml

# Check inputs
, pytestCheckHook
}:
let
  pname = "sacrebleu";
  version = "2.3.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjpost";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+58dhQv5LkjccjktfoAG2gqja6TMLIxHIbRgzZPDhKo=";
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

  checkInputs = [
    pytestCheckHook
  ];

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
    homepage = "https://github.com/mjpost/sacrebleu";
    changelog = "https://github.com/mjpost/sacrebleu/blob/v{version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
