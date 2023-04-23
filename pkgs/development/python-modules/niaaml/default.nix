{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, numpy
, pandas
, poetry-core
, scikit-learn
, toml-adapt
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "niaaml";
  version = "1.1.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lukapecnik";
    repo = "NiaAML";
    rev = version;
    hash = "sha256-B87pI1EpZj1xECrgTmzN5S35Cy1nPowBRyu1IDb5zCE=";
  };

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaaml"
  ];

  meta = with lib; {
    description = "Python automated machine learning framework";
    homepage = "https://github.com/lukapecnik/NiaAML";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
