{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# dependencies
, argon2-cffi
, certifi
, urllib3
, pycryptodome
, typing-extensions

# test
, faker
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "minio";
  version = "7.2.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-py";
    rev = "refs/tags/${version}";
    hash = "sha256-zK+D2DNgh1cASdA2gstNW0ODUu7Dn6vMY01mcrdSSo0=";
  };

  postPatch = ''
    substituteInPlace tests/unit/crypto_test.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "minio"
  ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = "https://github.com/minio/minio-py";
    changelog = "https://github.com/minio/minio-py/releases/tag/${version}";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
