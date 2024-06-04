{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  git,
  hatchling,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "hatch-vcs";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "hatch_vcs";
    inherit version;
    hash = "sha256-CTgQdI/gHbDUUfq88sGsJojK79Iy1O3pZwkLHBsH2fc=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    hatchling
    setuptools-scm
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    # incompatible with setuptools-scm>=7
    # https://github.com/ofek/hatch-vcs/issues/8
    "test_write"
  ];

  pythonImportsCheck = [ "hatch_vcs" ];

  meta = with lib; {
    changelog = "https://github.com/ofek/hatch-vcs/releases/tag/v${version}";
    description = "A plugin for Hatch that uses your preferred version control system (like Git) to determine project versions";
    homepage = "https://github.com/ofek/hatch-vcs";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
