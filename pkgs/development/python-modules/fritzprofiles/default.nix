{ lib
, buildPythonPackage
, fetchPypi
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "fritzprofiles";
  version = "0.7.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VoKgLJWF9x8dW8A6CNwLtK+AmehtgZP41nUGQO819es=";
  };

  propagatedBuildInputs = [
    lxml
    requests
  ];

  pythonImportsCheck = [
    "fritzprofiles"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool to switch the online time of profiles in the AVM Fritz!Box";
    homepage = "https://github.com/AaronDavidSchneider/fritzprofiles";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
