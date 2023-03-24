{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
, pytest-benchmark
, pytest-mock
, py
, pathos
, tqdm
}:

buildPythonPackage rec {
  pname = "lox";
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kXfFRIFI1OcbDc1LujbFo/Iqg7pgwtXLkIcIFA9nehs=";
  };

  # patch out pytest-runner and invalid pytest args
  preBuild = ''
    sed -i '/pytest-runner/d' ./setup.py
    sed -i '/collect_ignore/d' ./setup.cfg
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-benchmark
    pytest-mock
  ];

  propagatedBuildInputs = [
    pathos
    tqdm
  ];

  pythonImportsCheck = [
    "lox"
  ];

  meta = with lib; {
    description = "Threading and Multiprocessing made easy";
    homepage = "https://github.com/BrianPugh/lox";
    changelog = "https://github.com/BrianPugh/lox/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
