{
  lib,
  buildPythonPackage,
  fetchPypi,

  cmake,
  ninja,
  zig_0_16,
  # build-system
  hatchling,
  scikit-build-core,
  hatch-vcs,
  nanobind,
  # deps
  anthropic,
  antlr4-python3-runtime,
  atopile-easyeda2kicad,
  atopile-kicad-python,
  black,
  case-converter,
  cookiecutter,
  dataclasses-json,
  deprecated,
  fastapi,
  fastapi-github-oidc,
  freetype-py,
  gitpython,
  httpx,
  jinja2,
  keyring,
  kicadcliwrapper,
  matplotlib,
  mcp,
  more-itertools,
  natsort,
  numpy,
  openai,
  ordered-set,
  pathvalidate,
  pint,
  platformdirs,
  posthog,
  prompt-toolkit,
  psutil,
  pyaaf2,
  pydantic-settings,
  pygls,
  pytest,
  pyyaml,
  questionary,
  requests,
  rich,
  ruamel-yaml,
  ruff,
  semver,
  sexpdata,
  shapely,
  truststore,
  typer,
  typing-extensions,
  urllib3,
  uvicorn,
  watchdog,
  websockets,
  zstd,
  pythonOlder,

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "atopile";
  version = "0.15.7";
  pyproject = true;

  disabled = pythonOlder "3.14";

  # Upstream did not publish a GitHub tag for this version. The PyPI sdist
  # also includes the PKG-INFO metadata needed by hatch-vcs without a Git checkout.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HGYDkFm6Hic69pZTF+aEtJ0beeUyW4/QKcmtL+Q7O1U=";
  };

  # Upstream pins a fork of scikit-build-core (editable-mode patch) we don't need.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'scikit-build-core @ git+https://github.com/atopile/scikit-build-core.git@feature/allow_editable' \
        'scikit-build-core' \
      --replace-fail '"ziglang==0.16.0",' ""
  '';

  build-system = [
    hatchling
    scikit-build-core
    hatch-vcs
    nanobind
  ];

  dontUseCmakeConfigure = true; # skip cmake configure invocation

  # The CMake build shells out to `python -m ziglang ...` (the ziglang pip
  # wheel, not packaged in nixpkgs). Provide a shim module that execs the real
  # zig, and give zig a writable cache dir.
  preBuild = ''
    mkdir -p zigshim/ziglang
    touch zigshim/ziglang/__init__.py
    printf 'import os, sys\nos.execv("%s/bin/zig", ["zig", *sys.argv[1:]])\n' "${zig_0_16}" > zigshim/ziglang/__main__.py
    export PYTHONPATH="$PWD/zigshim:$PYTHONPATH"
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    zig_0_16 # replaces the ziglang pip build-dep; build calls zig to compile faebryk core
  ];

  dependencies = [
    anthropic
    antlr4-python3-runtime
    atopile-easyeda2kicad
    atopile-kicad-python
    black # used as a dependency
    case-converter
    cookiecutter
    dataclasses-json
    deprecated
    fastapi
    fastapi-github-oidc
    freetype-py
    gitpython
    httpx
    jinja2
    keyring
    kicadcliwrapper
    matplotlib
    mcp
    more-itertools
    natsort
    numpy
    openai
    ordered-set
    pathvalidate
    pint
    platformdirs
    posthog
    prompt-toolkit
    psutil
    pyaaf2
    pydantic-settings
    pygls
    pytest # imported at runtime
    pyyaml
    questionary
    requests
    rich
    ruamel-yaml
    ruff
    semver
    sexpdata
    shapely
    truststore
    typer
    typing-extensions
    urllib3
    uvicorn
    watchdog
    websockets
    zstd
  ];

  pythonRelaxDeps = [
    "atopile-easyeda2kicad" # nixpkgs has 0.9.7, atopile wants >=0.9.9
    "deprecated"
    "more-itertools" # nixpkgs has 10.8.0, atopile wants >=11
    "posthog"
    "prompt-toolkit"
    "ruff"
  ];

  pythonImportsCheck = [ "atopile" ];

  # Run the import and CLI version checks without pytest, which would collect
  # network/KiCad-dependent integration tests as well as tests under src/.
  nativeCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Design circuit boards with code";
    homepage = "https://atopile.io";
    downloadPage = "https://github.com/atopile/atopile";
    changelog = "https://github.com/atopile/atopile/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thecodedkid ];
    mainProgram = "ato";
  };
})
