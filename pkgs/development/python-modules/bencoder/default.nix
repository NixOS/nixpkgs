{
  lib,
  fetchPypi,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "bencoder";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rENvM/3X51stkFdJHSq+77VjHvsTyBNAPbCtsRq1L8I=";
  };

  pythonImportsCheck = [ "bencoder" ];

  # There are no tests.
  doCheck = false;

  meta = with lib; {
    description = "Simple bencode decoder/encoder library in pure Python";
    homepage = "https://github.com/utdemir/bencoder";
    license = licenses.gpl2;
    maintainers = with maintainers; [ somasis ];
  };
}
