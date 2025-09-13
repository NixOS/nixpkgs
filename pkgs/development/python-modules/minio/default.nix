{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  argon2-cffi,
  certifi,
  urllib3,
  pycryptodome,
  typing-extensions,

  # test
  faker,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "minio";
  version = "7.2.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    tag = version;
    hash = "sha256-NyHdZKHyok7CbzNZscUJm67+LK4hYkMp/p14M5vm7og=";
  };

  postPatch = ''
    substituteInPlace tests/unit/crypto_test.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = [ setuptools ];

  dependencies = [
    argon2-cffi
    certifi
    urllib3
    pycryptodome
    typing-extensions
  ];

  nativeCheckInputs = [
    faker
    mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # example credentials aren't present
    "tests/unit/credentials_test.py"
  ];

  pythonImportsCheck = [ "minio" ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = "https://github.com/minio/minio-py";
    changelog = "https://github.com/minio/minio-py/releases/tag/${src.tag}";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
