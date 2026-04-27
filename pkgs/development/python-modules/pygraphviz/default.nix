{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  graphviz,
  coreutils,
  pkg-config,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "pygraphviz";
  version = "1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygraphviz";
    repo = "pygraphviz";
    tag = "pygraphviz-${version}";
    hash = "sha256-RyUmT2djj2GnVG82xO9HULMAJZb2LYMUGDRvCwaYBg8=";
  };

  patches = [
    # pygraphviz depends on graphviz executables and wc being in PATH
    (replaceVars ./path.patch {
      path = lib.makeBinPath [
        graphviz
        coreutils
      ];
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

  meta = {
    description = "Python interface to Graphviz graph drawing package";
    homepage = "https://github.com/pygraphviz/pygraphviz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      dotlambda
    ];
  };
}
