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

<<<<<<< HEAD
  meta = {
    description = "Simple bencode decoder/encoder library in pure Python";
    homepage = "https://github.com/utdemir/bencoder";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ somasis ];
=======
  meta = with lib; {
    description = "Simple bencode decoder/encoder library in pure Python";
    homepage = "https://github.com/utdemir/bencoder";
    license = licenses.gpl2;
    maintainers = with maintainers; [ somasis ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
