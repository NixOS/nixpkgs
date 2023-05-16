{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, exceptiongroup
, poetry-core
}:

buildPythonPackage rec {
  pname = "generic";
<<<<<<< HEAD
  version = "1.1.2";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NfUvmkUIAdm+UZqmBWh0MZTViLJSkeRonPNSnVd+RbA=";
=======
    hash = "sha256-UHz2v6K5lNYb7cxBViTfPkpu2M8LItApGoSg3Bb2bqI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    exceptiongroup
  ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/generic";
<<<<<<< HEAD
    changelog = "https://github.com/gaphor/generic/releases/tag/${version}";
    license = licenses.bsd3;
=======
    license = licenses.bsdOriginal;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
