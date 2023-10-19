{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, scikit-learn
, termcolor
, tqdm
, pandas
# test dependencies
, tensorflow
, torch
, datasets
, torchvision
, keras
, fasttext
}:
let
  pname = "cleanlab";
  version = "2.4.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cleanlab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XFrjjBJA0OQEAspnQQiSIW4td0USJDXTp9C/91mobp8=";
  };

  # postPatch = ''
  #   substituteInPlace pyproject.toml \
  #     --replace '"rich <= 13.0.1"' '"rich"' \
  #     --replace '"numpy < 1.24.0"' '"numpy"'
  # '';

  propagatedBuildInputs = [
    scikit-learn
    termcolor
    tqdm
    pandas
  ];

  nativeCheckInputs = [
    tensorflow
    torch
    datasets
    torchvision
    keras
    fasttext
  ];

  meta = with lib; {
    description = "The standard data-centric AI package for data quality and machine learning with messy, real-world data and labels.";
    homepage = "https://github.com/cleanlab/cleanlab";
    changelog = "https://github.com/cleanlab/cleanlab/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
