{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  graphviz,
  coreutils,
  pkg-config,
  setuptools,
  swig,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygraphviz";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygraphviz";
    repo = "pygraphviz";
    tag = "pygraphviz-${finalAttrs.version}";
    hash = "sha256-l0kAGlO8AFJcSQgoCXM0+HyzyseUJVVeJQ7E8sKCnr0=";
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "swig>4.1.0"' ""
  '';

  env.GRAPHVIZ_PREFIX = graphviz;

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    graphviz # for dot
    pkg-config
    swig
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
    changelog = "https://github.com/pygraphviz/pygraphviz/releases/tag/pygraphviz-${finalAttrs.version}";
    description = "Python interface to Graphviz graph drawing package";
    homepage = "https://github.com/pygraphviz/pygraphviz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      dotlambda
    ];
  };
})
