{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  build,
  hatchling,
  tomli,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "hatch-fancy-pypi-readme";
  version = "25.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hatch_fancy_pypi_readme";
    inherit version;
    hash = "sha256-nFjtPf+Q1R9DQUzjcAmtHVsPCP/J/CFpmKBjgPAcAEU=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    hatchling
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [
    build
    pytestCheckHook
  ];

  # Requires network connection
  disabledTests = [
    "test_build" # Requires internet
    "test_invalid_config"
  ];

  pythonImportsCheck = [ "hatch_fancy_pypi_readme" ];

  meta = with lib; {
    description = "Fancy PyPI READMEs with Hatch";
    mainProgram = "hatch-fancy-pypi-readme";
    homepage = "https://github.com/hynek/hatch-fancy-pypi-readme";
    license = licenses.mit;
  };
}
