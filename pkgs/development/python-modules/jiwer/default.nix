{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonRelaxDepsHook
, rapidfuzz
, click
}:

buildPythonPackage rec {
  pname = "jiwer";
  version = "3.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bH5TE6mcSG+WqvjW8Sd/o5bCBJmv9zurFEG2cVY/vYQ=";
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

  pythonImportsCheck = [ "jiwer" ];

  meta = with lib; {
    description = "A simple and fast python package to evaluate an automatic speech recognition system";
    homepage = "https://github.com/jitsi/jiwer";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
