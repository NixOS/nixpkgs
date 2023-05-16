{ lib
<<<<<<< HEAD
, stdenv
, buildPythonPackage
, fetchFromGitHub
, flit-core
, matplotlib
, matplotx
, numpy
=======
, buildPythonPackage
, fetchFromGitHub
, flit-core
, dufte
, matplotlib
, numpy
, pipdate
, tqdm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rich
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "perfplot";
  version = "0.10.2";
  format = "pyproject";
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bu6eYQukhLE8sLkS3PbqTgXOqJFXJYXTcXAhmjaq48g=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    matplotlib
    matplotx
    numpy
    rich
  ];

  # This variable is needed to suppress the "Trace/BPT trap: 5" error in Darwin's checkPhase.
  # Not sure of the details, but we can avoid it by changing the matplotlib backend during testing.
  env.MPLBACKEND = lib.optionalString stdenv.isDarwin "Agg";

=======
    dufte
    matplotlib
    numpy
    pipdate
    rich
    tqdm
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "perfplot"
  ];
=======
  pythonImportsCheck = [ "perfplot" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Performance plots for Python code snippets";
    homepage = "https://github.com/nschloe/perfplot";
<<<<<<< HEAD
    changelog = "https://github.com/nschloe/perfplot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
    broken = true; # missing matplotx dependency
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
