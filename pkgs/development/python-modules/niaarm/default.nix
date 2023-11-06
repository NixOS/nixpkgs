{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, nltk
, numpy
, pandas
, poetry-core
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "niaarm";
  version = "0.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaARM";
    rev = "refs/tags/${version}";
    hash = "sha256-E5G1uVDSErqwxTBNQ7qselemW9A3W8sr3ExPEh+1les=";
  };

   pythonRelaxDeps = [
    "nltk"
    "niapy"
    "numpy"
    "pandas"
    "tomli"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    poetry-core
  ];

  propagatedBuildInputs = [
    niapy
    nltk
    pandas
    tomli
  ];

  disabledTests = [
    # Test requires extra nltk data dependency
    "test_text_mining"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaarm"
  ];

  meta = with lib; {
    description = "A minimalistic framework for Numerical Association Rule Mining";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    changelog = "https://github.com/firefly-cpp/NiaARM/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
