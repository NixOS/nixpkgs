{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvesync";
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/hPDCqTeqEzxfqv8B5wdDzmzzNuXYqOVHX32N/J6nmU=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Test are not available (not in PyPI tarball and there are no GitHub releases)
  doCheck = false;

  pythonImportsCheck = [
    "pyvesync"
  ];

  meta = with lib; {
    description = "Python library to manage Etekcity Devices and Levoit Air Purifier";
    homepage = "https://github.com/webdjoe/pyvesync";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
