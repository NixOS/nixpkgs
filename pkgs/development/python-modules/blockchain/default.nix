{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
}:

buildPythonPackage rec {
  pname = "blockchain";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qpbmz6dk5gx1996dswpipwhj6sp5j0dlfap012l46zqnvmkxanv";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "enum-compat" ""
  '';

  propagatedBuildInputs = [ future ];

  # tests are interacting with the API and not mocking the calls
  doCheck = false;

  pythonImportsCheck = [ "blockchain" ];

<<<<<<< HEAD
  meta = {
    description = "Python client Blockchain Bitcoin Developer API";
    homepage = "https://github.com/blockchain/api-v1-client-python";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python client Blockchain Bitcoin Developer API";
    homepage = "https://github.com/blockchain/api-v1-client-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
