{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, setuptools-scm
, hatchling
, attrs
, deprecated
, hepunits
, pytestCheckHook
, tabulate
, pandas
}:

buildPythonPackage rec {
  pname = "particle";
  version = "0.21.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Mw9IVQoXZU8ByU6OI2Wtmo3PJuVz6KzzH7I+pPYkssQ=";
  };
  nativeBuildInputs = [
    setuptools-scm
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    deprecated
    hepunits
  ];

  pythonImportsCheck = [
    "particle"
  ];

  preCheck = ''
    # Disable benchmark tests, so we won't need pytest-benchmark and pytest-cov
    # as dependencies
    substituteInPlace pyproject.toml \
      --replace '"--benchmark-disable", ' ""
    rm tests/particle/test_performance.py
  '';

  checkInputs = [
    pytestCheckHook
    tabulate
    pandas
  ];

  meta = {
    description = "Package to deal with particles, the PDG particle data table, PDGIDs, etc.";
    homepage = "https://github.com/scikit-hep/particle";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
