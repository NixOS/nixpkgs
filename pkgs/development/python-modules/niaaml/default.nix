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
  typing-extensions,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "niaaml";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaAML";
    tag = version;
    hash = "sha256-j3vnslVvktfhtRsR1hw+WfLGbhmjdUzhY+HLR9EWD7o=";
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
    typing-extensions
  ];

  # create scikit-learn and niapy deps version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
    toml-adapt -path pyproject.toml -a change -dep niapy -ver X
  '';

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "niaaml" ];

  meta = {
    description = "Python automated machine learning framework";
    homepage = "https://github.com/firefly-cpp/NiaAML";
    changelog = "https://github.com/firefly-cpp/NiaAML/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
