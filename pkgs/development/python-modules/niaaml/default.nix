{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, numpy
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, scikit-learn
, toml-adapt
}:

buildPythonPackage rec {
  pname = "niaaml";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "NiaAML";
    rev = "refs/tags/${version}";
    hash = "sha256-jGbsxYlRJ81g74LqSKpquciPsLP+KSoNBTJPEaD/CHM=";
  };

  pythonRelaxDeps = [
    "pandas"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
    toml-adapt
  ];

  propagatedBuildInputs = [
    niapy
    numpy
    pandas
    scikit-learn
  ];

  # create scikit-learn and niapy deps version consistent
  preBuild = ''
    toml-adapt -path pyproject.toml -a change -dep scikit-learn -ver X
    toml-adapt -path pyproject.toml -a change -dep niapy -ver X
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaaml"
  ];

  meta = with lib; {
    description = "Python automated machine learning framework";
    homepage = "https://github.com/firefly-cpp/NiaAML";
    changelog = "https://github.com/firefly-cpp/NiaAML/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
