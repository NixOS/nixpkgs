{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GeospatialPython";
    repo = "pyshp";
    rev = version;
    hash = "sha256-yfxhgk8a1rdpGVkE1sjJqT6tiFLimhu2m2SjGxLI6wo=";
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
