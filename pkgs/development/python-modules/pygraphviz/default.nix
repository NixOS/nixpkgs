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
  version = "1.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+hj3xs6ig0Gk5GbtDPBWgrCmgoiv6N18lCZ4L3wa4Bw=";
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

  checkInputs = [ pytest ];

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
