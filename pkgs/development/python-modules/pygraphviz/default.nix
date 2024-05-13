{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, graphviz
, coreutils
, pkg-config
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "pygraphviz";
  version = "1.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pygraphviz";
    repo = "pygraphviz";
    rev = "refs/tags/pygraphviz-${version}";
    hash = "sha256-/H7eHgs3jtbgat8//1Y1S3iV5s0UBKW+J+zK+f8qGqI=";
  };

  patches = [
    # pygraphviz depends on graphviz executables and wc being in PATH
    (substituteAll {
      src = ./path.patch;
      path = lib.makeBinPath [ graphviz coreutils ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

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
