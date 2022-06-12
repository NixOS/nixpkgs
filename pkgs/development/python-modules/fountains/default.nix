{ lib
, buildPythonPackage
, fetchPypi
, bitlist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fountains";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-c6nw22UtAREYZp0XCEZE6p7GpRvSLukq5y0c9KvVf9w=";
  };

  propagatedBuildInputs = [
    bitlist
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "fountains"
  ];

  meta = with lib; {
    description = "Python library for generating and embedding data for unit testing";
    homepage = "https://github.com/reity/fountains";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
