{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  niapy,
  numpy,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  toml-adapt,
  tomli,
  torch,
}:

buildPythonPackage rec {
  pname = "nianet";
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SasoPavlic";
    repo = "nianet";
    tag = "version_${version}";
    sha256 = "sha256-FZipl6Z9AfiL6WH0kvUn8bVxt8JLdDVlmTSqnyxe0nY=";
  };

  build-system = [
    poetry-core
    toml-adapt
  ];

  dependencies = [
    niapy
    numpy
    scikit-learn
    torch
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  # create niapy and torch dep version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep niapy -ver X
    toml-adapt -path pyproject.toml -a change -dep torch -ver X
  '';

  nativeCheckInputs = [
    pytestCheckHook
    tomli
  ];

  pythonImportsCheck = [ "nianet" ];

  meta = with lib; {
    description = "Designing and constructing neural network topologies using nature-inspired algorithms";
    homepage = "https://github.com/SasoPavlic/NiaNet";
    changelog = "https://github.com/SasoPavlic/NiaNet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
