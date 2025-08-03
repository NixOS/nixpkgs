{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GeospatialPython";
    repo = "pyshp";
    tag = version;
    hash = "sha256-NBZCqCbrCUIowj/EwWfC1vNC1fyNdg7EC06RRi6pul0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shapefile" ];

  disabledTests = [
    # Requires network access
    "test_reader_url"
  ];

  meta = with lib; {
    description = "Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
    maintainers = [ ];
  };
}
