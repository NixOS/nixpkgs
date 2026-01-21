{
  lib,
  fetchPypi,
  buildPythonPackage,
  agate,
  dbf,
  dbfread,
}:

buildPythonPackage rec {
  pname = "agate-dbf";
  version = "0.2.4";
  format = "setuptools";

  propagatedBuildInputs = [
    agate
    dbf
    dbfread
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZVSCixAEinbbtbxO/4kR4FnqK0cVW3qJNR44KRXKFvw=";
  };

  meta = {
    description = "Adds read support for dbf files to agate";
    homepage = "https://github.com/wireservice/agate-dbf";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}
