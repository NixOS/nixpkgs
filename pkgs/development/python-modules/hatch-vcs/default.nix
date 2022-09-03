{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, git
, hatchling
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "hatch-vcs";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hatch_vcs";
    inherit version;
    sha256 = "sha256-mRPXM7NO7JuwNF0GJsoyFlpK0t4V0c5kPDbQnKkIq/8=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    hatchling
    setuptools-scm
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    # incompatible with setuptools-scm>=7
    # https://github.com/ofek/hatch-vcs/issues/8
    "test_write"
  ];

  pythonImportsCheck = [
    "hatch_vcs"
  ];

  meta = with lib; {
    description = "A plugin for Hatch that uses your preferred version control system (like Git) to determine project versions";
    homepage = "https://github.com/ofek/hatch-vcs";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
