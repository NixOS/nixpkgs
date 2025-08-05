{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GeospatialPython";
    repo = "pyshp";
    tag = version;
    hash = "sha256-bN6n/cHuhoJPP2N9hcaPY87QgLNDSNdjHkpmyjO/+70=";
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
