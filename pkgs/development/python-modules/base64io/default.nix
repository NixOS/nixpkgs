{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  setuptools,
  unstableGitUpdater,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "base64io";
  version = "1.0.3-unstable-2025-01-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "base64io-python";
    rev = "1bd47f7f8cfeeff654ea0edda3fbb69f840ccd05";
    hash = "sha256-1MUWjFFitJ3nqvVwAQYcAVVPhPs6NEgq7t/mI71u2Bk=";
  };

  patches = [
    (fetchpatch2 {
      name = "default-buffer-size-compat.patch";
      url = "https://github.com/abus-sh/base64io-python/commit/a929dc3c9d873eabe491ccae9a2d0d57726f37da.patch?full_index=1";
      hash = "sha256-VfPOZ8cDRW2mQy6ROl77kBRE780NhH4kbjkyD1/jMRk=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://base64io-python.readthedocs.io/";
    changelog = "https://github.com/aws/base64io-python/blob/${version}/CHANGELOG.rst";
    description = "Python stream implementation for base64 encoding/decoding";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
