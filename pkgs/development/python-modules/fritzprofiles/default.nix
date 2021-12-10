{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "fritzprofiles";
  version = "0.7.3";
  format = "setuptools";

  src = fetchFromGitHub {
     owner = "AaronDavidSchneider";
     repo = "fritzprofiles";
     rev = "v0.7.3";
     sha256 = "1gbmzcbicpcc94rawz1cvs5xcl90lj5dwn94r7ijaswm9h4dqgy0";
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
