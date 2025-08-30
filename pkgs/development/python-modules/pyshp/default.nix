{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeospatialPython";
    repo = "pyshp";
    tag = version;
    hash = "sha256-bN6n/cHuhoJPP2N9hcaPY87QgLNDSNdjHkpmyjO/+70=";
  };

  build-system = [ hatchling ];

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
