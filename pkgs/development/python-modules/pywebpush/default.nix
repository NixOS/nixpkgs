{ lib
, buildPythonPackage
, coverage
, cryptography
, fetchPypi
, flake8
, http-ece
, mock
, py-vapid
, pytestCheckHook
, requests
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.14.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+I1+K/XofGFt+wS4yVwRkjjFEWWbAvc17nfMFoQoVe4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    http-ece
    py-vapid
    requests
    six
  ];

  nativeCheckInputs = [
    coverage
    flake8
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pywebpush"
  ];

  meta = with lib; {
    description = "Webpush Data encryption library for Python";
    homepage = "https://github.com/web-push-libs/pywebpush";
    changelog = "https://github.com/web-push-libs/pywebpush/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "pywebpush";
  };
}
