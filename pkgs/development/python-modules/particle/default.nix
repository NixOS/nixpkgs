{ lib
, attrs
, buildPythonPackage
, deprecated
, fetchFromGitHub
, fetchPypi
, hatch-vcs
, hatchling
, hepunits
, pandas
, pytestCheckHook
, pythonOlder
, setuptools-scm
, tabulate
}:

buildPythonPackage rec {
  pname = "particle";
  version = "0.23.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2BD4/CfeuOf9ZBdAF9lgfVBSIknAlzoACOWA+T2xF1A=";
  };

  postPatch = ''
    # Disable benchmark tests, so we won't need pytest-benchmark and pytest-cov
    # as dependencies
    substituteInPlace pyproject.toml \
      --replace '"--benchmark-disable",' ""
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    deprecated
    hepunits
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tabulate
    pandas
  ];

  pythonImportsCheck = [
    "particle"
  ];

  disabledTestPaths = [
    "tests/particle/test_performance.py"
  ];

  meta = with lib; {
    description = "Package to deal with particles, the PDG particle data table and others";
    homepage = "https://github.com/scikit-hep/particle";
    changelog = "https://github.com/scikit-hep/particle/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
