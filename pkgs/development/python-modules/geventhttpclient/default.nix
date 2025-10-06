{
  lib,
  brotli,
  buildPythonPackage,
  certifi,
  dpkt,
  fetchFromGitHub,
  gevent,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  stdenv,
  urllib3,
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "2.3.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "geventhttpclient";
    repo = "geventhttpclient";
    tag = version;
    # TODO: unvendor llhttp
    fetchSubmodules = true;
    hash = "sha256-X85co03fMG7OSpkL02n3ektRNzu7oHChtwZzkspsSTk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    brotli
    certifi
    gevent
    urllib3
  ];

  nativeCheckInputs = [
    dpkt
    pytestCheckHook
  ];

  # lots of: [Errno 48] Address already in use: ('127.0.0.1', 54323)
  doCheck = !stdenv.hostPlatform.isDarwin;

  __darwinAllowLocalNetworking = true;

  disabledTestMarks = [ "network" ];

  pythonImportsCheck = [ "geventhttpclient" ];

  meta = with lib; {
    homepage = "https://github.com/geventhttpclient/geventhttpclient";
    description = "High performance, concurrent HTTP client library using gevent";
    changelog = "https://github.com/geventhttpclient/geventhttpclient/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
