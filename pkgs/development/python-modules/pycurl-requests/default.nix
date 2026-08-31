{
  buildPythonPackage,
  chardet,
  fetchFromGitHub,
  lib,
  pycurl,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "pycurl-requests";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dcoles";
    repo = "pycurl-requests";
    tag = "v${version}";
    hash = "sha256-3EEwwCuJZHf9ePC4sMRHL6tujdGVF6LfHVAIDpLXV7k=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    chardet
    pycurl
  ];

  disabledTests = [
    # tests that require network access
    "test_connecterror_refused"
    "test_get_connect_timeout"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pycurl_requests" ];

  meta = {
    description = "Requests-compatible interface for PycURL";
    homepage = "https://github.com/dcoles/pycurl-requests";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
