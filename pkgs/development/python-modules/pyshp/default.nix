{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GeospatialPython";
    repo = "pyshp";
    tag = version;
    hash = "sha256-q1++2pifLZWc562m5cKoL2jLWM4lOnIwEAOqzKArh+w=";
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
