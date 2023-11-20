{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonRelaxDepsHook
, rapidfuzz
, click
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jiwer";
  version = "3.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z+M0/mftitLV2OaaQvTdRehtt16FFeBjqR//S5ad1XE=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    rapidfuzz
    click
  ];

  pythonRelaxDeps = [
    "rapidfuzz"
  ];

  pythonImportsCheck = [
    "jiwer"
  ];

  meta = with lib; {
    description = "A simple and fast python package to evaluate an automatic speech recognition system";
    homepage = "https://github.com/jitsi/jiwer";
    changelog = "https://github.com/jitsi/jiwer/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
