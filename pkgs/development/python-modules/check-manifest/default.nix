{ lib
, breezy
, build
, buildPythonPackage
, fetchPypi
, fetchpatch
, git
, mock
, pep517
, pytestCheckHook
, toml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.49";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZKZARFVCzyJpGWV8e3jQLZwcpbHCXX5m4OH/MlBg9BY=";
  };

  patches = [
    # Fix git submodule tests using file: protocol
    (fetchpatch {
      url = "https://github.com/mgedmin/check-manifest/pull/159.patch";
      hash = "sha256-CDtuIoHgP4THLt+xF32C/OrjakwPOEVTKUh5JuQB5wM=";
    })
  ];

  propagatedBuildInputs = [
    build
    pep517
    toml
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/mgedmin/check-manifest/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
