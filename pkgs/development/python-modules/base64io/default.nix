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
  version = "1.0.3-unstable-2025-01-09";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "base64io-python";
    rev = "1bd47f7f8cfeeff654ea0edda3fbb69f840ccd05";
    hash = "sha256-1MUWjFFitJ3nqvVwAQYcAVVPhPs6NEgq7t/mI71u2Bk=";
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
