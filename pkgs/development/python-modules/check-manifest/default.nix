{
  lib,
  breezy,
  build,
  buildPythonPackage,
  fetchPypi,
  git,
  pep517,
  pytestCheckHook,
  setuptools,
  tomli,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.49";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZKZARFVCzyJpGWV8e3jQLZwcpbHCXX5m4OH/MlBg9BY=";
  };

  propagatedBuildInputs = [
    build
    pep517
    setuptools
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  checkInputs = [ breezy ];

  disabledTests = [
    # Test wants to setup a venv
    "test_build_sdist_pep517_isolated"
  ];

  pythonImportsCheck = [ "check_manifest" ];

  meta = with lib; {
    description = "Check MANIFEST.in in a Python source package for completeness";
    mainProgram = "check-manifest";
    homepage = "https://github.com/mgedmin/check-manifest";
    changelog = "https://github.com/mgedmin/check-manifest/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
