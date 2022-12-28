{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "GeospatialPython";
    repo = pname;
    rev = version;
    hash = "sha256-yfxhgk8a1rdpGVkE1sjJqT6tiFLimhu2m2SjGxLI6wo=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "shapefile"
  ];

  disabledTests = [
    # Requires network access
    "test_reader_url"
  ];

  meta = with lib; {
    description = "Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
