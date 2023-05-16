{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub

# build-system
, poetry-core

# unpropagated
, pytest

# propagated
, inflection
, factory_boy
, typing-extensions

# tests
, pytestCheckHook
=======
, factory_boy
, fetchFromGitHub
, inflection
, mock
, pytest
, pytestcache
, pytestCheckHook
, pytest-cov
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-factoryboy";
<<<<<<< HEAD
  version = "2.5.1";
  format = "pyproject";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-factoryboy";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-zxgezo2PRBKs0mps0qdKWtBygunzlaxg8s9BoBaU1Ig=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];
=======
    sha256 = "0v6b4ly0p8nknpnp3f4dbslfsifzzjx2vv27rfylx04kzdhg4m9p";
  };

  buildInputs = [ pytest ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    factory_boy
    inflection
<<<<<<< HEAD
    typing-extensions
  ];

  pythonImportsCheck = [
    "pytest_factoryboy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--ignore=docs"
  ];
=======
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytestcache
    pytest-cov
  ];

  pytestFlagsArray = [ "--ignore=docs" ];
  pythonImportsCheck = [ "pytest_factoryboy" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Integration of factory_boy into the pytest runner";
    homepage = "https://pytest-factoryboy.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ winpat ];
    license = licenses.mit;
  };
}
