{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  siphash24,
  columnize,
  hatch-requirements-txt,
  tccbox,
  hatch-sphinx,
  sphinx,
  pytestCheckHook,
  numpy,
  scipy,
  bumps,
  docutils,
  matplotlib,
  opencl-headers,
  pycuda,
  pyopencl,
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

  build-system = [
    hatchling
    hatch-vcs
    siphash24
    columnize
    hatch-requirements-txt
    tccbox
    hatch-sphinx
    sphinx
  ];

  buildInputs = [ opencl-headers ];

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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
