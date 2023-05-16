{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
, pytestCheckHook
, setuptools
, stevedore
, wheel
=======
, stevedore
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "plux";
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  # Tests are not available from PyPi
  src = fetchFromGitHub {
    owner = "localstack";
    repo = "plux";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-AybMHkCUNJsL51XwiskkIltEtqZ27fGHrpyct8IUjmo=";
  };

  patches = [
    # https://github.com/localstack/plux/pull/8
    (fetchpatch {
      name = "remove-pytest-runner.patch";
      url = "https://github.com/localstack/plux/commit/3cda22e51f43a86304d0dedd7e554b21aa82c8b0.patch";
      hash = "sha256-ZFHUTkUYFSTgKbx+c74JQzre0la+hFW9gNOxOehvVoE=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    # Request for proper tags: https://github.com/localstack/plux/issues/4
    rev = "a412ab0a0d7d17c3b5e1f560b7b31dc1876598f7";
    hash = "sha256-zFwrRc93R4cXah7zYXjVLBIeBpDedsInxuyXOyBI8SA=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    stevedore
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plugin.core" ];

  meta = with lib; {
    description = "Dynamic code loading framework for building pluggable Python distributions";
    homepage = "https://github.com/localstack/plux";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
