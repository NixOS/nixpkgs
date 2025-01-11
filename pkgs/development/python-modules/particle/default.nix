{
  lib,
  attrs,
  buildPythonPackage,
  deprecated,
  fetchPypi,
  hatch-vcs,
  hatchling,
  hepunits,
  pandas,
  pytestCheckHook,
  pythonOlder,
  tabulate,
}:

buildPythonPackage rec {
  pname = "particle";
  version = "0.25.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H6S77ji/6u8IpAsnebTDDFzk+ihloQwCrP6QZ5tOYek=";
  };

  postPatch = ''
    # Disable benchmark tests, so we won't need pytest-benchmark and pytest-cov
    # as dependencies
    substituteInPlace pyproject.toml \
      --replace '"--benchmark-disable",' ""
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    attrs
    deprecated
    hepunits
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tabulate
    pandas
  ];

  pythonImportsCheck = [ "particle" ];

  disabledTestPaths = [
    # Requires pytest-benchmark and pytest-cov which we want to avoid using, as
    # it doesn't really test functionality.
    "tests/particle/test_performance.py"
  ];

  meta = {
    description = "Package to deal with particles, the PDG particle data table and others";
    homepage = "https://github.com/scikit-hep/particle";
    changelog = "https://github.com/scikit-hep/particle/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
