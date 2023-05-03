{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sabctools";
  version = "7.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AB5/McuOIDkhu7rtb3nFaqOTx3zwm92+3NEnH5HjzBo=";
  };

  # Tests are not included in pypi distribution
  doCheck = false;

  pythonImportsCheck = [
    "sabctools"
  ];

  meta = with lib; {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 ];
  };
}
