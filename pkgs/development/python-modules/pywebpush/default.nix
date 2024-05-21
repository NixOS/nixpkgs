{ lib
, aiohttp
, buildPythonPackage
, cryptography
, fetchPypi
, http-ece
, mock
, py-vapid
, pytestCheckHook
, pythonOlder
, requests
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A8zD6XW2A3S3Y0xJVZVha+Ujvyx9oNl26E/amsjGMwE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    cryptography
    http-ece
    py-vapid
    requests
    six
  ];

  nativeCheckInputs = [
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
