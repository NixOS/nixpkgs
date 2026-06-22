{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pandas,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycatch22";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DynamicsAndNeuralSystems";
    repo = "pycatch22";
    tag = "v${version}";
    hash = "sha256-NvZrjOdC6rV4hwCuGcc2Br/VDhLwZcYpfnNvQpqU134=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pandas
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pycatch22" ];

  meta = {
    description = "Python implementation of catch22";
    homepage = "https://github.com/DynamicsAndNeuralSystems/pycatch22";
    changelog = "https://github.com/DynamicsAndNeuralSystems/pycatch22/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
