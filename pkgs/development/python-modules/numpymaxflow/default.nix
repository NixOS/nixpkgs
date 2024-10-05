{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  python,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "numpymaxflow";
  version = "0.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "masadcv";
    repo = "numpymaxflow";
    rev = "refs/tags/v${version}";
    hash = "sha256-s1Pbab3vK0Co1KQev+/4+IRqyLzqUXBixz4b0ndq+5k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "numpy==1.26.0" "numpy"
  '';

  build-system = [
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "numpymaxflow" ];

  doCheck = false; # no tests

  meta = {
    description = "Numpy-based implementation of max-flow/min-cut (graphcut) for 2D/3D data";
    homepage = "https://github.com/masadcv/numpymaxflow";
    changelog = "https://github.com/masadcv/numpymaxflow/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
