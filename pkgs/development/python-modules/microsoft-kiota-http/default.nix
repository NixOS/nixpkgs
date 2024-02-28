{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, httpx
, microsoft-kiota-abstractions
, opentelemetry-api
, opentelemetry-sdk
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, urllib3
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-http";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-http-python";
    rev = "v${version}";
    hash = "sha256-BGMEndYa1ZMKWw18Fs9S/ieMhu+e4tKQW57CC3g0P0Q=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    httpx
    microsoft-kiota-abstractions
    opentelemetry-api
    opentelemetry-sdk
  ] ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "kiota_http" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    urllib3
  ];

  meta = {
    changelog = "https://github.com/microsoft/kiota-http-python/blob/${src.rev}/CHANGELOG.md";
    description = "HTTP request adapter implementation for Kiota clients for Python";
    homepage = "https://github.com/microsoft/kiota-http-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
