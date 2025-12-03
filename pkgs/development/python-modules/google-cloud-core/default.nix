{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  google-api-core,
  google-auth,
  grpcio,
  grpcio-status,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-cloud-core";
    tag = "v${version}";
    hash = "sha256-hYOtpHIHJVITrei6/0m1YteTog2WBWCUFCl/Zr6BLlc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    google-api-core
  ];

  optional-dependencies = {
    grpc = [
      grpcio
      grpcio-status
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ optional-dependencies.grpc;

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud" ];

  meta = with lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    changelog = "https://github.com/googleapis/python-cloud-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
