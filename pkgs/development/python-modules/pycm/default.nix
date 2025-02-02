{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pytestCheckHook,
  pytest-cov-stub,
  seaborn,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycm";
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oceLARBP9D6NlMQiDvzIpJNNcod5D1O4xo3YzrUstso=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
    seaborn
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    matplotlib
  ];

  disabledTests = [
    "plot_error_test" # broken doctest (expects matplotlib import exception)
  ];

  postPatch = ''
    # Remove a trivial dependency on the author's `art` Python ASCII art library
    rm pycm/__main__.py
    substituteInPlace setup.py \
      --replace-fail '=get_requires()' '=[]'
  '';

  pythonImportsCheck = [ "pycm" ];

  meta = {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.io";
    changelog = "https://github.com/sepandhaghighi/pycm/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
