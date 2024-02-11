{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "python-wink";
  version = "1.10.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r6qabnqxyy3llnj10z60d4w9pg2zabysl3l7znpy1adss4ywxl0";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pywink" ];

  meta = with lib; {
    description = "Python implementation of the Wink API";
    homepage = "https://github.com/python-wink/python-wink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
