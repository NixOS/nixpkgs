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
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bDbhZ5JoIZ5pO6lA2yvyVMJAygJmTeECtyaa/DxUVzE=";
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
    homepage = "https://github.com/web-push-libs/pywebpush";
    license = licenses.mpl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
