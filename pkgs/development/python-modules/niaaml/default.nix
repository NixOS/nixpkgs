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
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaAML";
    tag = version;
    hash = "sha256-i5hjmvN9qJCGVDmRDBTiaNQn+1kZHr2iWNnD7GUimr4=";
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

  meta = with lib; {
    description = "Python automated machine learning framework";
    homepage = "https://github.com/firefly-cpp/NiaAML";
    changelog = "https://github.com/firefly-cpp/NiaAML/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
