{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  pythonOlder,
  cffi,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "3.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QzxBDCF3BXcF2iqfLNAd0VdJOyp6wUyFk6FrPatra/s=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    six
    cffi
  ];

  propagatedNativeBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bcrypt" ];

<<<<<<< HEAD
  meta = {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
