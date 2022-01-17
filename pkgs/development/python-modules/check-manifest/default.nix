{ lib
, breezy
, build
, buildPythonPackage
, fetchPypi
, git
, mock
, pep517
, pytestCheckHook
, toml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.47";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VtrdJgqcfVULFZeW0olLbQvMF2qUy8Qm2buT5eSNEs4=";
  };

  propagatedBuildInputs = [
    build
    pep517
    toml
  ];

  checkInputs = [
    breezy
    git
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Test wants to setup a venv
    "test_build_sdist_pep517_isolated"
  ];

  pythonImportsCheck = [
    "check_manifest"
  ];

  meta = with lib; {
    description = "Check MANIFEST.in in a Python source package for completeness";
    homepage = "https://github.com/mgedmin/check-manifest";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
