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
  version = "1.0.3-unstable-2023-10-30";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "base64io-python";
    rev = "604817576e607d1f7f8af1ffa1530522fd4e4be2";
    hash = "sha256-RFl0iuyHdPf3VpBxH4m/N2yaKEBxkNMT1ldZP9VGGOk=";
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
