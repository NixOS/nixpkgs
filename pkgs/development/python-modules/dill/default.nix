{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,

  # passthru tests
  apache-beam,
  datasets,
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.4.0-unstable-2025-11-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "dill";
    rev = "d948ecd748772f2812361982ec1496da0cd47b53";
    hash = "sha256-/A84BpZnwSwsEYqLL0Xdf8OjJtg1UMu6dig3QEN+n1A=";
  };

  nativeBuildInputs = [ setuptools ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} dill/tests/__main__.py
    runHook postCheck
  '';

  passthru.tests = {
    inherit apache-beam datasets;
  };

  pythonImportsCheck = [ "dill" ];

  meta = {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    changelog = "https://github.com/uqfoundation/dill/releases/tag/dill-${version}";
    license = lib.licenses.bsd3;
  };
}
