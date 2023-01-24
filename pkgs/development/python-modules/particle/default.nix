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
  version = "0.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SDdIg05+gfLNaQ+glitTf3Z/6K9HBci62mjIu9rIoX0=";
  };

  nativeBuildInputs = [
    setuptools-scm
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

  preCheck = ''
    # Disable benchmark tests, so we won't need pytest-benchmark and pytest-cov
    # as dependencies
    substituteInPlace pyproject.toml \
      --replace '"--benchmark-disable", ' ""
    rm tests/particle/test_performance.py
  '';



  meta = with lib; {
    description = "Package to deal with particles, the PDG particle data table and others";
    homepage = "https://github.com/scikit-hep/particle";
    changelog = "https://github.com/scikit-hep/particle/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
