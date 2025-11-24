{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdfrw,
}:

buildPythonPackage rec {
  pname = "pagelabels";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GAEyhECToKnIWBxnYTSOsYKZBjl50b/82mZ68i8I2ug=";
  };

  buildInputs = [ pdfrw ];

  # upstream doesn't contain tests
  doCheck = false;

  meta = with lib; {
    description = "Python library to manipulate PDF page labels";
    homepage = "https://github.com/lovasoa/pagelabels-py";
    maintainers = with maintainers; [ teto ];
    license = licenses.gpl3;
  };
}
