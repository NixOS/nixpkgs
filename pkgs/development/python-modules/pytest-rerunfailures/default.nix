{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, packaging
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
<<<<<<< HEAD
  version = "12.0";
=======
  version = "11.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-eE9GL6h/6b33gdACfYVrR6S/5sEq8Qj2vYhwV6kXtI4=";
=======
    hash = "sha256-VWEWYehz8cr6OEyC8I0HiDlU9LdkNfS4pbRwwZVFc94=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
