{ lib
, attrs
, buildPythonPackage
, docutils
, fetchPypi
, od
, pygments
, pytestCheckHook
, pythonOlder
, python-dateutil
, repeated-test
, setuptools-scm
, sigtools
}:

buildPythonPackage rec {
  pname = "clize";
<<<<<<< HEAD
  version = "5.0.2";
=======
  version = "5.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BH9aRHNgJxirG4VnKn4VMDOHF41agcJ13EKd+sHstRA=";
=======
    hash = "sha256-/cFpEvAN/Movd38xaE53Y+D9EYg/SFyHeqtlVUo1D0I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
  ];

  passthru.optional-dependencies = {
    datetime = [
      python-dateutil
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    pygments
    repeated-test
  ];

  pythonImportsCheck = [
    "clize"
  ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
