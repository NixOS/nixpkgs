{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdfrw,
}:

buildPythonPackage (finalAttrs: {
  pname = "pagelabels";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-GAEyhECToKnIWBxnYTSOsYKZBjl50b/82mZ68i8I2ug=";
  };

  dependencies = [
    pdfrw
  ];

  # upstream doesn't contain tests
  doCheck = false;

  meta = {
    description = "Python library to manipulate PDF page labels";
    homepage = "https://github.com/lovasoa/pagelabels-py";
    maintainers = with lib.maintainers; [ teto ];
    license = lib.licenses.gpl3;
  };
})
