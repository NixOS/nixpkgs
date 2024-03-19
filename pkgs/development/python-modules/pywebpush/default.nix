{ lib
, fetchPypi
, buildPythonPackage
, cryptography
, http-ece
, py-vapid
, requests
, six
, coverage
, flake8
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "1.14.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+I1+K/XofGFt+wS4yVwRkjjFEWWbAvc17nfMFoQoVe4=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "pywebpush" ];

  meta = with lib; {
    description = "Webpush Data encryption library for Python";
    mainProgram = "pywebpush";
    homepage = "https://github.com/web-push-libs/pywebpush";
    license = licenses.mpl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
