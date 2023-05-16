{ lib
, buildPythonPackage
, fetchPypi
, graphviz
, graphvizPkgs
, isPyPy
<<<<<<< HEAD
, python
=======
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, substituteAll
}:

buildPythonPackage rec {
  pname = "objgraph";
<<<<<<< HEAD
  version = "3.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NpVnw3tPL5KBYLb27e3L6o/H6SmDGHf9EFbHipAMF9M=";
=======
  version = "3.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.5" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R1LKW8wOBRLkG4zE0ngKwv07PqvQO36VClWUwGID38Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      graphviz = graphvizPkgs;
    })
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    ipython = [
      graphviz
    ];
  };
=======
  propagatedBuildInputs = [
    graphviz
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "objgraph"
  ];

<<<<<<< HEAD
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests.py
    runHook postCheck
  '';
=======
  pytestFlagsArray = [
    "tests.py"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Draws Python object reference graphs with graphviz";
    homepage = "https://mg.pov.lt/objgraph/";
    changelog = "https://github.com/mgedmin/objgraph/blob/${version}/CHANGES.rst";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ dotlambda ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
