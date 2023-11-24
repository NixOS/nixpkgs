{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FDUwEi7lEwUJrV6YnwUS98shiy1O3br7rUD9EOjYzL4=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "googlesearch"
  ];

  meta = with lib; {
    description = "Python bindings to the Google search engine";
    homepage = "https://pypi.org/project/google/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
