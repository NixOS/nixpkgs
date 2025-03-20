{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  niapy,
  numpy,
  pandas,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  toml-adapt,
}:

buildPythonPackage rec {
  pname = "niaclass";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaClass";
    tag = version;
    hash = "sha256-cowB+nBb5vH2ntLrcctqICYcf3I4m8rw3g4vO3/rokw=";
  };

  pythonRelaxDeps = [
    "numpy"
    "pandas"
  ];

  nativeBuildInputs = [
    poetry-core
    toml-adapt
  ];

  propagatedBuildInputs = [
    niapy
    numpy
    pandas
    scikit-learn
  ];

  # create scikit-learn dep version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niaclass" ];

  meta = with lib; {
    description = "Framework for solving classification tasks using Nature-inspired algorithms";
    homepage = "https://github.com/firefly-cpp/NiaClass";
    changelog = "https://github.com/firefly-cpp/NiaClass/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
