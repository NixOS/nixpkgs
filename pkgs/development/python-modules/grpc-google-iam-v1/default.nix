{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  googleapis-common-protos,
  grpcio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpc-google-iam-v1";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-grpc-google-iam-v1";
    tag = "v${version}";
    hash = "sha256-CkzXh7psXQvAbAduRR6+Bihv6RlaOAWdFDX7xaqWO8M=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    grpcio
    googleapis-common-protos
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "google.iam"
    "google.iam.v1"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "GRPC library for the google-iam-v1 service";
    homepage = "https://github.com/googleapis/python-grpc-google-iam-v1";
    changelog = "https://github.com/googleapis/python-grpc-google-iam-v1/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
