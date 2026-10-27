{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  build,
  hatchling,
}:

buildPythonPackage rec {
  pname = "hatch-fancy-pypi-readme";
  version = "25.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "hatch_fancy_pypi_readme";
    inherit version;
    hash = "sha256-nFjtPf+Q1R9DQUzjcAmtHVsPCP/J/CFpmKBjgPAcAEU=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    hatchling
  ];

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

  meta = {
    description = "Fancy PyPI READMEs with Hatch";
    mainProgram = "hatch-fancy-pypi-readme";
    homepage = "https://github.com/hynek/hatch-fancy-pypi-readme";
    license = lib.licenses.mit;
  };
}
