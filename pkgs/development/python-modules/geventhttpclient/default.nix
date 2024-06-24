{
  lib,
  brotli,
  buildPythonPackage,
  certifi,
  dpkt,
  fetchFromGitHub,
  gevent,
  llhttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
  stdenv,
  urllib3,
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "geventhttpclient";
    repo = "geventhttpclient";
    rev = "refs/tags/${version}";
    # TODO: unvendor llhttp
    fetchSubmodules = true;
    hash = "sha256-uOGnwPbvTam14SFTUT0UrwxHfP4a5cn3a7EhLoGBUrA=";
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
  doCheck = !stdenv.isDarwin;

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    rm -rf geventhttpclient
  '';

  pytestFlagsArray = [ "-m 'not network'" ];

  pythonImportsCheck = [ "geventhttpclient" ];

  meta = with lib; {
    homepage = "https://github.com/geventhttpclient/geventhttpclient";
    description = "High performance, concurrent HTTP client library using gevent";
    changelog = "https://github.com/geventhttpclient/geventhttpclient/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
