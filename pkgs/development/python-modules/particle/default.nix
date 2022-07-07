{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, setuptools-scm
, attrs
, deprecated
, hepunits
, pytestCheckHook
, tabulate
, pandas
}:

buildPythonPackage rec {
  pname = "particle";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HoWWwoGMrkRqlYzrF2apGsxsZAHwHbHSO5TCSCelxUc=";
  };
  nativeBuildInputs = [
    setuptools-scm
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
