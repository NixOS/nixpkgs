{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  niapy,
  numpy,
  pandas,
  poetry-core,
  pytestCheckHook,
  scikit-learn,
  toml-adapt,
  typer,
}:

buildPythonPackage rec {
  pname = "niaaml";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaAML";
    tag = version;
    hash = "sha256-AUQhdJc2nSuggV6zNOMihVJIbHAQX6EXsnhn97Tp35A=";
  };

  pythonRelaxDeps = [
    "numpy"
    "pandas"
    "typer"
  ];

  build-system = [
    poetry-core
    toml-adapt
  ];

  dependencies = [
    loguru
    niapy
    numpy
    pandas
    scikit-learn
    typer
  ];

  # create scikit-learn and niapy deps version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
    toml-adapt -path pyproject.toml -a change -dep niapy -ver X
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niaaml" ];

  meta = {
    description = "Python automated machine learning framework";
    homepage = "https://github.com/firefly-cpp/NiaAML";
    changelog = "https://github.com/firefly-cpp/NiaAML/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
