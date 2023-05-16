{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libyaml
, python
}:

buildPythonPackage rec {
  pname = "pyyaml";
<<<<<<< HEAD
  version = "6.0.1";

  disabled = pythonOlder "3.6";

  format = "pyproject";

=======
  version = "6.0";

  disabled = pythonOlder "3.6";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-YjWMyMVDByLsN5vEecaYjHpR1sbBey1L/khn4oH9SPA=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];
=======
    hash = "sha256-wcII32mRgRRmAgojntyxBMQkjvxU2jylCgVzlHAj2Xc=";
  };

  nativeBuildInputs = [ cython ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libyaml ];

  checkPhase = ''
    runHook preCheck
    PYTHONPATH="tests/lib:$PYTHONPATH" ${python.interpreter} -m test_all
    runHook postCheck
  '';

  pythonImportsCheck = [ "yaml" ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = "https://github.com/yaml/pyyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
