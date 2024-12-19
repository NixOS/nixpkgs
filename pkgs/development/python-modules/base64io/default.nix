{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "base64io";
  version = "1.0.3-unstable-2024-06-24";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "base64io-python";
    rev = "f3dd88bf0db6eb412c55ff579f0aa9f39d970c41";
    hash = "sha256-znQlPlS+jzPiHNBvnDnZ8l1pZP6iuYqExDlPii4dJwM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://base64io-python.readthedocs.io/";
    changelog = "https://github.com/aws/base64io-python/blob/${version}/CHANGELOG.rst";
    description = "Python stream implementation for base64 encoding/decoding";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
