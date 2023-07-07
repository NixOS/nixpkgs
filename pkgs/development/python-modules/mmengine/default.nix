{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, torch
, opencv4
, yapf
, coverage
, mlflow
, lmdb
, matplotlib
, numpy
, pyyaml
, rich
, termcolor
, addict
, parameterized
}:

buildPythonPackage rec {
  pname = "mmengine";
  version = "0.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eridbYHagwAyXX3/JggfvC0vuy6nBAIISRy1ARrQ7Kk=";
  };

  # tests are disabled due to sandbox env.
  disabledTests = [
    "test_fileclient"
    "test_http_backend"
    "test_misc"
  ];

  nativeBuildInputs = [ pytestCheckHook ];

  nativeCheckInputs = [
    coverage
    lmdb
    mlflow
    torch
    parameterized
  ];

  propagatedBuildInputs = [
    addict
    matplotlib
    numpy
    pyyaml
    rich
    termcolor
    yapf
    opencv4
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "mmengine"
  ];

  meta = with lib; {
    description = "a foundational library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ rxiao ];
  };
}
