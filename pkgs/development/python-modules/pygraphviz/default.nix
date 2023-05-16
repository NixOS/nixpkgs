{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, substituteAll
, graphviz
, coreutils
, pkg-config
, pytest
}:

buildPythonPackage rec {
  pname = "pygraphviz";
<<<<<<< HEAD
  version = "1.11";
=======
  version = "1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-qX61ztJm9FBT67HyxsbSkJFpBQPjpcFL5/kIs3sG8tQ=";
=======
    hash = "sha256-RX4JOoiBKJAyUaJmqMwWtLqT8/YzSz6/7ZLHRxp02Gc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extension = "zip";
  };

  patches = [
    # pygraphviz depends on graphviz executables and wc being in PATH
    (substituteAll {
      src = ./path.patch;
      path = lib.makeBinPath [ graphviz coreutils ];
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ graphviz ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    runHook preCheck
    pytest --pyargs pygraphviz
    runHook postCheck
  '';

  pythonImportsCheck = [ "pygraphviz" ];

  meta = with lib; {
    description = "Python interface to Graphviz graph drawing package";
    homepage = "https://github.com/pygraphviz/pygraphviz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasbeyer dotlambda ];
  };
}
