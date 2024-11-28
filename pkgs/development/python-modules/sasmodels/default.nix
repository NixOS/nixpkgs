{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  numpy,
  scipy,
  bumps,
  docutils,
  matplotlib,
  opencl-headers,
  pycuda,
  pyopencl,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "refs/tags/v${version}";
    hash = "sha256-fa6/13z11AuTRItZOEmTbjpU1aT6Ur7evi6UvVvXQck=";
  };

  build-system = [ setuptools ];

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
      # columnize
    ];
    server = [ bumps ];
    opencl = [ pyopencl ];
    cuda = [ pycuda ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.full;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "sasmodels" ];

  meta = with lib; {
    description = "Library of small angle scattering models";
    homepage = "https://github.com/SasView/sasmodels";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprospero ];
  };
}
