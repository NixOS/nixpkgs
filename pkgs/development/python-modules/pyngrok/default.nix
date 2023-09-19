{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "6.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9fT2fnntBQ7y+c52tuqHM7iVAqoLgwAs6izmuZRUNiI=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    homepage = "https://github.com/alexdlaird/pyngrok";
    description = "A Python wrapper for ngrok";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
