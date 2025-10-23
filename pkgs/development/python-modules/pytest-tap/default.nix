{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  pythonOlder,
  pytest,
  tappy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-tap";
  version = "3.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-tap";
    repo = "pytest-tap";
    rev = "v${version}";
    hash = "sha256-IuVtH1hrynbFDmz7IZ6vef9bAwl8L1eqR9WYQVL6CCA=";
  };

  patches = [
    (fetchpatch {
      # see https://github.com/python-tap/pytest-tap/pull/105
      name = "missing-package-in-wheel.patch";
      url = "https://github.com/python-tap/pytest-tap/commit/056a44a632b1af19d9ba4b5044768bde3dd6a764.patch";
      hash = "sha256-P52NqgXtnO2SthDwVbT+NVPeBNhjGS/8Vsbe/WLCc3A=";
    })
  ];

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ tappy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_tap" ];

  meta = with lib; {
    description = "Test Anything Protocol (TAP) reporting plugin for pytest";
    homepage = "https://github.com/python-tap/pytest-tap";
    changelog = "https://github.com/python-tap/pytest-tap/blob/v${version}/docs/releases.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cynerd ];
  };
}
