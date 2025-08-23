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
  version = "1.0.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    tag = "v${version}";
    hash = "sha256-cTXFlTCm521+xhcggFvDqVZrTJuDiVZ8PazBwA3mKJU=";
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
