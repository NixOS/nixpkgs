{ lib
, buildPythonPackage
, setuptools
, isPyPy
, fetchPypi
, pythonOlder
, cffi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "3.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QzxBDCF3BXcF2iqfLNAd0VdJOyp6wUyFk6FrPatra/s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    six
    cffi
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bcrypt"
  ];

  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
