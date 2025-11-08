{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  columnize,
  hatch-requirements-txt,
  hatch-sphinx,
  hatch-vcs,
  hatchling,
  siphash24,
  sphinx,

  numpy,
  scipy,
  bumps,
  docutils,
  matplotlib,
  opencl-headers,
  pycuda,
  pyopencl,

  # optional-dependencies

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    tag = "v${version}";
    hash = "sha256-AtFkcW7h2hMnQAeAk0fGsARXwpuaSb7ERBhdnAH4pCY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"tccbox",' ""
  '';

  build-system = [
    columnize
    hatch-requirements-txt
    hatch-sphinx
    hatch-vcs
    hatchling
    siphash24
    sphinx
  ];

  buildInputs = [ opencl-headers ];

  pythonRemoveDeps = [
    "tccbox" # unpackaged
  ];
  dependencies = [
    numpy
    scipy
  ];

  optional-dependencies = {
    full = [
      docutils
      bumps
      matplotlib
      columnize
    ];
    server = [ bumps ];
    opencl = [ pyopencl ];
    cuda = [ pycuda ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.full;

  pythonImportsCheck = [ "sasmodels" ];

  meta = {
    description = "Library of small angle scattering models";
    homepage = "https://github.com/SasView/sasmodels";
    changelog = "https://github.com/SasView/sasmodels/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
