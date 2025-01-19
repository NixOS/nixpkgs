{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest7CheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "rangehttpserver";
  version = "1.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danvk";
    repo = "RangeHTTPServer";
    tag = version;
    hash = "sha256-wvGJ5wHYLb7wJUGgurkdRTABV6kTH7/GXzXgpd0Ypbc=";
  };

  nativeBuildInputs = [ setuptools ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest7CheckHook
    requests
  ];

  pythonImportsCheck = [ "RangeHTTPServer" ];

  meta = with lib; {
    description = "SimpleHTTPServer with support for Range requests";
    homepage = "https://github.com/danvk/RangeHTTPServer";
    changelog = "https://github.com/danvk/RangeHTTPServer/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
