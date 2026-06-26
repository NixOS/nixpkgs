{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,
  graphviz,
  coreutils,
  pkg-config,
  setuptools,
  swig,
  pytest,
}:

buildPythonPackage {
  pname = "pygraphviz";
  version = "1.14-unstable-2026-05-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygraphviz";
    repo = "pygraphviz";
    rev = "6b9efcd1a76a97836de79d1380c0d003c6f834e7";
    hash = "sha256-ghtnwOevSnecshMBoASCZircgOsPF7+l+Cer+J+yEqM=";
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

    # https://github.com/pygraphviz/pygraphviz/pull/573
    substituteInPlace pygraphviz/graphviz.i \
      --replace-fail '%cstring_output_allocate_size(char **result, unsigned int* size, free(*$1));' \
                     '%cstring_output_allocate_size(char **result, size_t* size, free(*$1));' \
      --replace-fail 'int gvRenderData(GVC_t *gvc, Agraph_t* g, char *format, char **result, unsigned int *size);' \
                     'int gvRenderData(GVC_t *gvc, Agraph_t* g, char *format, char **result, size_t *size);'
  '';

  env.GRAPHVIZ_PREFIX = graphviz;

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
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
    description = "Python interface to Graphviz graph drawing package";
    homepage = "https://github.com/pygraphviz/pygraphviz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      dotlambda
    ];
  };
}
