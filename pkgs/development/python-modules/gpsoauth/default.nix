{ lib
, buildPythonPackage
, fetchPypi
, pycryptodomex
, pythonOlder
, requests
}:

buildPythonPackage rec {
  version = "1.0.2";
  format = "setuptools";
  pname = "gpsoauth";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-68rnLrMlp/BsvqlbnV5kvsJTcDEtsV6OLkbE1U5ynno=";
  };

  propagatedBuildInputs = [ pycryptodomex requests ];

  # upstream tests are not very comprehensive
  doCheck = false;

  pythonImportsCheck = [ "gpsoauth" ];

  meta = with lib; {
    description = "Library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };
}
