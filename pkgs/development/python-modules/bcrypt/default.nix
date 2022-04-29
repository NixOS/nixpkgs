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
  version = "3.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29";
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
