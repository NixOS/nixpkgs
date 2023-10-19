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
  version = "1.11";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qX61ztJm9FBT67HyxsbSkJFpBQPjpcFL5/kIs3sG8tQ=";
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
