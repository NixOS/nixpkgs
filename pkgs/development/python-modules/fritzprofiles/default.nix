{ lib
, buildPythonPackage
, fetchPypi
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "fritzprofiles";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bd4sa3i1ldkg6lnsvg004csgqklvi5xk71y971qyjvsbdbwgbn3";
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
