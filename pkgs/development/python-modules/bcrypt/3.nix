{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  cffi,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "3.2.2";
  pyproject = true;

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

  meta = {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
