{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "eagle100";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i9ZvbjxSENJlQ+9sqWnIl1fL6tVbG3E/IUhe7b59sBk=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "eagle100"
  ];

  meta = with lib; {
    description = "Python library for interacting with Rainforest EAGLE devices";
    homepage = "https://github.com/hastarin/eagle100";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
